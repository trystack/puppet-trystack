#!/bin/bash
neutron net-create tun-mon
neutron subnet-create tun-mon 10.0.0.0/24
