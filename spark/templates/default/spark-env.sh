#!/usr/bin/env bash

# This file contains environment variables required to run Spark. Copy it as
# spark-env.sh and edit that to configure Spark for your site. At a minimum,
# the following two variables should be set:
# - MESOS_NATIVE_LIBRARY, to point to your Mesos native library (libmesos.so)
# - SCALA_HOME, to point to your Scala installation
#
# If using the standalone deploy mode, you can also set variables for it:
# - SPARK_MASTER_IP, to bind the master to a different IP address
# - SPARK_MASTER_PORT / SPARK_MASTER_WEBUI_PORT, to use non-default ports
# - SPARK_WORKER_CORES, to set the number of cores to use on this machine
# - SPARK_WORKER_MEMORY, to set how much memory to use (e.g. 1000m, 2g)
# - SPARK_WORKER_PORT / SPARK_WORKER_WEBUI_PORT
#
# Finally, Spark also relies on the following variables, but these can be set
# on just the *master* (i.e. in your driver program), and will automatically
# be propagated to workers:
# - SPARK_MEM, to change the amount of memory used per node (this should
#   be in the same format as the JVM's -Xmx option, e.g. 300m or 1g)
# - SPARK_CLASSPATH, to add elements to Spark's classpath
# - SPARK_JAVA_OPTS, to add JVM options
# - SPARK_LIBRARY_PATH, to add extra search paths for native libraries.

export SCALA_HOME="/usr"

# add scala jars to classpath
export SPARK_CLASSPATH="$SPARK_CLASSPATH:$(find /usr/share/java/ | grep scala | tr '\n' ':')"

export SPARK_WORKER_PORT=8080
export SPARK_WORKER_WEBUI_PORT=8081

export SPARK_MEM="<%= @mem %>"

