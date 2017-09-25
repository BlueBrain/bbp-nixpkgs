"""Install HTML documentation according to
Viz documentation web app expections. See:
    https://bbpteam.epfl.ch/project/spaces/x/_YufAQ
"""

from __future__ import print_function

import datetime
import json
import logging
import os
import os.path as osp
import stat
import sys


TODAY = datetime.datetime.today().strftime('%Y-%m-%d')
GIT_HOSTING_SERVICES = [
    'github.com',
    'bitbucket.org',
    'gitlab.',
]


def get_required_env(name):
    """Get specified environment variable or raise an Exception
    """
    try:
        return os.environ[name]
    except KeyError:
        message = 'Expected "{}" environment variable'
        raise EnvironmentError(message.format(name))


def get_pkgs():
    """Retrieve Pythonic list of documentation packages to install
    """
    pkgs = get_required_env('pkgs')
    try:
        pkgs = json.loads(pkgs)
    except ValueError:
        message = 'Expected JSON in "pkgs" environment variable'
        raise EnvironmentError(message)
    if not isinstance(pkgs, list):
        message = 'Expected JSON list in "pkgs" environment variable'
        raise EnvironmentError(message)
    return [Package(pkg) for pkg in pkgs]


def lookup_dir(root, name):
    """Find a directory
    """
    top = root
    while osp.exists(root):
        content = os.listdir(root)
        for subdir in content:
            if subdir == name:
                return osp.join(root, subdir)
        if len(content) > 1:
            raise EnvironmentError('Could not find unique sub-dir in ' + root)
        root = osp.join(root, content[0])
    raise EnvironmentError('Could not find "html" directory in ' + top)


class Package(object):
    """Documentation package
    """
    def __init__(self, pkg):
        self._pkg = pkg

    @property
    def name(self):
        return self._pkg['name']

    @property
    def meta(self):
        return self._pkg.get('meta', {})

    @property
    def description(self):
        return self._get_meta_property('description', required=True)

    @property
    def homepage(self):
        return self._get_meta_property('homepage', required=True)

    @property
    def repository(self):
        default = ''
        repo = self.homepage
        for srv in GIT_HOSTING_SERVICES:
            if srv in repo:
                default = repo + '.git'
                break
        return self._get_meta_property('repository', default=default)

    @property
    def issueurl(self):
        default = self.homepage
        repo = self.repository
        if repo.endswith('.git'):
            repo = repo[:-len('.git')]
        for srv in GIT_HOSTING_SERVICES:
            if srv in repo:
                default = repo + '/issues'
                break
        return self._get_meta_property('issueurl', default)

    @property
    def maintainers(self):
        return self._get_meta_property('maintainers', [])

    @property
    def version(self):
        return self._pkg['version']

    @property
    def version_major(self):
        versions = self.version.split('.')
        return versions[0]

    @property
    def version_minor(self):
        versions = self.version.split('.')
        if len(versions) < 2:
            return ''
        return versions[1]

    @property
    def license(self):
        return self._get_meta_property('license', required=True)

    @property
    def project_description(self):
        return dict(
            name=self.name[:-(len(self.version) + 1)],
            version=self.version,
            major=self.version_major,
            minor=self.version_minor,
            description=self.description,
            packageurl=self.homepage,
            issueurl=self.issueurl,
            repository=self.repository,
            license=self.license.get('fullName'),
            maintainers=', '.join(self.maintainers),
            updated=TODAY,
        )

    @property
    def doc_path(self):
        return self._pkg['doc_path']

    def install(self, install_prefix):
        self._install_project_description(install_prefix)
        self._install_documentation(install_prefix)

    def _get_meta_property(self, name, default=None, required=False):
        if default is None:
            default = 'meta.' + name
        value = self.meta.get(name)
        if value is None:
            if required:
                raise Exception('Attribute "meta.{}" is missing'.format(name))
            return default
        return value

    def _install_documentation(self, install_prefix):
        html_doc_path = lookup_dir(self.doc_path, 'html')
        os.symlink(html_doc_path,
                   osp.join(install_prefix, self.name))

    def _install_project_description(self, install_prefix):
        projects_out_dir = osp.join(install_prefix, '_projects')
        if not osp.isdir(projects_out_dir):
            os.makedirs(projects_out_dir)
        meta_file = osp.join(projects_out_dir, self.name)
        with open(meta_file, 'w') as ostr:
            print('---', file=ostr)
            for key, value in self.project_description.items():
                print(key, ': ', value, sep='', file=ostr)
            print('---', file=ostr)


def install_sync_script(script, out, rsync):
    dest_dir = osp.join(out, 'bin')
    if not osp.isdir(dest_dir):
        os.makedirs(dest_dir)
    dest_file = osp.join(dest_dir, 'doc-git-sync')
    with open(dest_file, 'w') as ostr:
        with open(script) as istr:
            for line in istr:
                ostr.write(line.replace('@RSYNC@', rsync))
    st = os.stat(dest_file)
    os.chmod(dest_file, st.st_mode | stat.S_IEXEC)


def main():
    error_occured = False
    try:
        pkgs = get_pkgs()
        out = get_required_env('out')
        name = get_required_env('name')
        rsync = get_required_env('rsync')
    except EnvironmentError as e:
        error_occured = True
        logging.error(e)
    else:
        logging.basicConfig(
            level=logging.INFO,
            format='%(levelname)-7s%(name)-{}s %(message)s'.format(
                max([len(pkg.name) for pkg in pkgs])
            )
        )

        install_prefix = osp.join(out, 'share', name)
        error_occured = False
        for pkg in pkgs:
            logger = logging.root.getChild(pkg.name)
            logger.info('Installing HTML documentation')
            try:
                pkg.install(install_prefix)
            except Exception as e:
                error_occured = True
                logger.error(e)
    if sys.argv:
        install_sync_script(sys.argv[1], out, rsync)
    sys.exit(1 if error_occured else 0)


if __name__ == '__main__':
    main()
