FROM python:3.4

RUN apt-get update && apt-get install -y \
		libblas-dev \
		liblapack-dev\
    	libatlas-base-dev \
		gfortran \
		&& \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install \
       	ipykernel \
	scipy \
	pandas \
	scikit-learn \
	Pillow \
        jupyter \
        matplotlib \
	keras \
        && \
    python -m ipykernel.kernelspec

COPY jupyter_notebook_config.py /root/.jupyter/
COPY keras.json /root/.keras/

# Jupyter has issues with being run directly:
# https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

ENV TENSORFLOW_VERSION 0.10.0rc0

RUN pip --no-cache-dir install \
    	https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${TENSORFLOW_VERSION}-cp34-cp34m-linux_x86_64.whl

# tensorboard
EXPOSE 6006

# jupyter
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh"]
