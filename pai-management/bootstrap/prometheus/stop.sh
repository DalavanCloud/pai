#!/bin/sh

#!/bin/bash

# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

INSTANCES="daemonset/node-exporter
daemonset/watchdog
deployment/watchdog
deployment/prometheus-deployment
configmap/prometheus-configmap
configmap/prometheus-alert
configmap/watchdog
deployment/alertmanager
configmap/alertmanager
"

for instance in ${INSTANCES}; do
  kubectl delete --ignore-not-found --now ${instance}
done

{% for host in machinelist %}
    {% if 'prometheus' in machinelist[ host ] and machinelist[ host ][ 'prometheus' ] == 'true' %}
kubectl label nodes {{ machinelist[ host ][ 'nodename' ] }} prometheus- || exit $?
    {% endif %}
    {% if 'node-exporter' in machinelist[ host ] and machinelist[ host ][ 'node-exporter' ] == 'true' %}
kubectl label nodes {{ machinelist[ host ][ 'nodename' ] }} node-exporter- || exit $?
    {% endif %}
    {% if 'watchdog' in machinelist[ host ] and machinelist[ host ][ 'watchdog' ] == 'true' %}
kubectl label nodes {{ machinelist[ host ][ 'nodename' ] }} watchdog- || exit $?
    {% endif %}
    {% if 'alert-manager' in machinelist[ host ] and machinelist[ host ][ 'alert-manager' ] == 'true' %}
kubectl label nodes {{ machinelist[ host ][ 'nodename' ] }} alertmanager- || exit $?
    {% endif %}
{% endfor %}