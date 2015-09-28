# === Class: thrift::config
# 
# Class that installs all dependencies to compile and install Apache Thrift.

class thrift::config {
  case $::os_family {
    'debian': {
      include thrift::config::debian
    }
    defalt : {
      fail("The $::os_family operation system family is not supported yet.")
    }
  }
}