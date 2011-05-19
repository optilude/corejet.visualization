from setuptools import setup, find_packages

version = '1.0a3'

requires = [
    'setuptools',
    'lxml',
    'corejet.core',
    'unittest2',
]

setup(name='corejet.visualization',
      version=version,
      description="Support for generating reports visualizing CoreJet test runs",
      long_description=open("README.txt").read() + "\n" +
                       open("CHANGES.txt").read(),
      classifiers=[
        "Programming Language :: Python",
        ],
      keywords='corejet',
      author='Martin Aspeli',
      author_email='optilude@gmail.com',
      url='http://corejet.org',
      license='ZPL 2.1',
      packages=find_packages(exclude=['ez_setup']),
      namespace_packages=['corejet'],
      include_package_data=True,
      zip_safe=False,
      install_requires=requires,
      entry_points="""
      """,
      )
