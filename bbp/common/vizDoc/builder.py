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
            packageurl=self.homepage,
            description=self.description,
            repository=self.repository,
            issueurl=self.issueurl,
            maintainers=', '.join(self.maintainers),
            version=self.version,
            updated=TODAY,
            license=self.license.get('fullName'),
            major=self.version_major,
            minor=self.version_minor,
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


def main():
    error_occured = False
    try:
        pkgs = get_pkgs()
        out = get_required_env('out')
        name = get_required_env('name')
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
    sys.exit(1 if error_occured else 0)


if __name__ == '__main__':
    main()
