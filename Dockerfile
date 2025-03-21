# docker build -t bpowers/mstat .
FROM ubuntu:latest

WORKDIR /home/ubuntu
COPY . .

RUN apt-get update && \
    apt-get install -y \
	    vim git make \
	    gcc automake cmake \ 
      g++ autoconf golang \
      sudo

#compile mstat
RUN make && \
    make install

#compile jemalloc
RUN git clone https://github.com/jemalloc/jemalloc && \
    cd jemalloc && \
    ./autogen.sh --enable-doc=no --enable-static=no --disable-stats && \
    make -j 8 && \
    make install && \
    rm -rf ./src/*.o ./lib/*.a

#compile mesh
RUN git clone https://github.com/plasma-umass/mesh && \
    cd mesh && \
    cmake . && \
    make  && \
    cp build/lib/libmesh.so /usr/local/lib/

#compile mimalloc
RUN git clone https://github.com/microsoft/mimalloc.git && \
    cd mimalloc && \
    git checkout master && \
    cmake -B out/release && \
    cmake --build out/release --parallel 8 && \
    cp out/release/libmimalloc.so /usr/local/lib/
