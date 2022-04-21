FROM rockylinux:8.5
COPY etc/yum.repos.d/oneAPI.repo /etc/yum.repos.d
RUN yum install -y findutils
RUN yum install -y git make jq golang hwloc intel-oneapi-runtime-opencl intel-oneapi-runtime-compilers intel-oneapi-runtime-compilers-32bit
RUN ln -s /usr/lib64/libhwloc.so.15.2.0 /usr/lib64/libhwloc.so
ENTRYPOINT ["/bin/bash"]
