# === Class: thrift::config::debian
# 
# Class that installs all dependencies to compile and install Apache Thrift on Debian-based systems.

class thrift::config::debian {
  if ! defined(Package['libboost-dev']) {
    package { 'libboost-dev': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libboost-test-dev': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libboost-program-options-dev': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libboost-program-options-dev': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libboost-system-dev': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libboost-filesystem-dev': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libevent-dev': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'automake': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libtool': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'flex': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'bison': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'pkg-config': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'g++': ensure => present }
  }

  if ! defined(Package['libboost-dev']) {
    package { 'libssl-dev': ensure => present }
  }
}