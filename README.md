# Puppet-thrit

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What thrift affects](#what-thrift-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with thrift](#beginning-with-thrift)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Puppet module to install Apache Thrift compiler from its source code.
For now, this module only supports Debian-based systems.
It has been tested on puppet 3.8 and 4.2.

## Module Description

This module provide a `define` that downloads, compiles and installs the Apache Thrift compiler on
system from its source code. It is meant to be used on developer environment setup. A developer
may work in different projects concurrently. Those project can require different versions of Apache
Thrift compiler. Therefore, this moduled uses a `define` instead of a `class`, so it can allow
multiple version to be installed.

The module only provides the installation of the compiler. It can define a default version, but it
only works at installation time. It is not possible to switch default versions after installation.

## Setup

### What thrift affects

- Packages needed to compile Apache Thrift
- Available versions of Apache Thrift compiler in the system. The following files should be created:
  - `$PREFIX/bin/thrift-$VERSION`
  - `$PREFIX/bin/thrift` -> `$PREFIX/bin/thrift-$VERSION` (`default = true`)
  - `$PREFIX/lib/libthrift-$VERSION`
  - `$PREFIX/share/doc/thrift`

### Setup Requirements

This module relies on common applications in \*NIX systems for downloading and extracting the installer. Those are not checked as dependencies, namely:
- `wget`
- `tar`

Usually this applications are available out of the box in most systems, so you should not worry about them. However, if installing on containers, like Docker images, they may not be available.


### Beginning with thrift

To simply install the latest version of Apache Thrift, just declare a `thrift` resource.

```puppet
# install the latests version of 'thrift'
# on /usr/local
thrift { 'latest': }
```

## Usage

Any resource available through this module is provided by its main **defined type** `thrift`. The remaining manifests are only private support classes. They are meant to logically organize the many steps needed to install the compiler.

The thrift module downloads, compiles and installs the Apache Thrift compiler. It can install multiple versions concurrently. Internally, it manages the installation of dependent libraries and tools for compilation and installation time.

By default the module will install the latest version (0.9.2) into `/usr/local`. This will install `thrift-0.9.2` and `thrift` into `/usr/local/bin`. To install any other version, you can use the parameter `version`. For other installation path, use the parameter `prefix`:

```puppet
# install thrift compiler 0.8.0 into '/usr' and creates:
# - /usr/bin/thrift-0.8.0
# - /usr/bin/thrift -> /usr/bin/thrift-0.8.0
thrift { '0.8.0':
  version => '0.8.0',
  prefix  => '/usr'
}
```

## Reference

### Public Defined Types

#### Defined Type: `thrift`

Define that downloads, compiles and installs a given version of Apache Thrift compiler.
On installation adds the `thrift-$VERSION` to system `$PATH`.
A symlink to a default version as 'thrift' (only) can be added to system `$PATH` passing
the expected parameter.

```puppet
# install both versions 0.9.2 and 0.8.0 into '/usr'
# with '/usr/bin/thrift' -> '/usr/bin/thrift-0.9.2'

thrift { '0.9.2':
 prefix  => '/usr',
 version => '0.9.2',
 default => true
}

thrift { '0.8.0':
 prefix  => '/usr',
 version => '0.8.0',
 default => false
}
```

##### `prefix`
Overrides the default folders where Thrift compiler is installed.
The default is '/usr/local', installing thrift into:
- /usr/local/bin
- /usr/local/lib
- /usr/local/share/doc

##### `version`
The Thrift compiler version to be is installed. The default is the latest (0.9.2).

##### `default`
Whether this is the system's default version of Thrift compiler.
It creates a symlink 'thrift-$VERSION -> thrift' into $PREFIX/bin.
The default value is TRUE.

## Limitations

So far, this module only has support to **Debian-based** operation systems. The support to other \*NIX systems depends on porting the dependencies (e.g. libboost) installation.

This module has been tested on Puppet 3.8 and 4.2. However, it only relies on `package` and `exec` built-in types. Therefore, it should work with any Puppet version greater than 3.x.

## Development

If you like this Puppet module, but thinks you can improve it, please read our [quick guide to contribute][constributing-code-guide].

## Contributors

The list of contributors can be found at: https://github.com/instituto-stela/puppet-thrit/graphs/contributors.


[constributing-code-guide]: https://github.com/instituto-stela/guidelines/opensource/contributing.md
