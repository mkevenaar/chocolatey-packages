# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@9abedd955985420fc0726492cd23345d4c45a9d0/icons/hadoop.png" width="48" height="48"/> [hadoop](https://community.chocolatey.org/packages/hadoop)

The Apache Hadoop software library is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models. It is designed to scale up from single servers to thousands of machines, each offering local computation and storage. Rather than rely on hardware to deliver high-availability, the library itself is designed to detect and handle failures at the application layer, so delivering a highly-available service on top of a cluster of computers, each of which may be prone to failures.

The project includes these modules:

* Hadoop Common: The common utilities that support the other Hadoop modules.
* Hadoop Distributed File System (HDFS™): A distributed file system that provides high-throughput access to application data.
* Hadoop YARN: A framework for job scheduling and cluster resource management.
* Hadoop MapReduce: A YARN-based system for parallel processing of large data sets.

## Notes
The package sets the HADOOP\_HOME environment variable and adds HADOOP\_HOME\bin to the machine path.

The package by default will unzip to **C:\Hadoop**. This location can be changed, see below.

## Package Parameters
The following package parameters can be set:

* `/unzipLocation` - Unzip to a different path than default.

These parameters can be passed to the installer with the use of `-params`.
For example: `choco install hadoop -params '"/unzipLocation:D:\Hadoop"'`.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
