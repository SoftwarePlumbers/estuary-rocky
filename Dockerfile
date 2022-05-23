# Build Stage
FROM rockylinux:8.5 AS commonRuntime
COPY etc/yum.repos.d/oneAPI.repo /etc/yum.repos.d
# The intel postinstall scripts for the opencl stuff fail silently without find
RUN yum install -y findutils 
# OpenCL libraries - if we have a GPU we will want to change this
RUN yum install -y hwloc jq intel-oneapi-runtime-opencl intel-oneapi-runtime-compilers intel-oneapi-runtime-compilers-32bit
# Compatibility hack
RUN ln -s /usr/lib64/libhwloc.so.15.2.0 /usr/lib64/libhwloc.so

FROM commonRuntime AS builder
# Prepare Dependencies
RUN yum install -y git make golang 
RUN mkdir /scratch
WORKDIR /scratch
# Checkout source
RUN git clone https://github.com/application-research/estuary.git/
WORKDIR /scratch/estuary
# Run build
RUN make clean all

# Executable
FROM commonRuntime
RUN mkdir /data
COPY --from=builder /scratch/estuary/estuary /usr/local/bin
COPY --from=builder /scratch/estuary/estuary-shuttle /usr/local/bin
COPY usr/local/bin/entrypoint.sh /usr/local/bin
COPY etc/estuary /etc/estuary
COPY etc/estuary-shuttle /etc/estuary-shuttle
WORKDIR /data
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD estuary