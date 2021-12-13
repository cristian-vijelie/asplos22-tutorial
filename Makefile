# SPDX-License-Identifier: BSD-3-Clause
#
# Authors: Alexander Jung <a.jung@lancs.ac.uk>
#
# Copyright (c) 2021, Lancaster University.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the author nor the names of any co-contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

#
# Args
#
REG           ?= ghcr.io
ORG           ?= unikraft
REPO          ?= asplos22-tutorial
IMAGE         ?= $(REG)/$(ORG)/$(REPO)

#
# Dirs
#
WORKDIR       ?= $(CURDIR)

#
# Tools
#
DOCKER        ?= docker

#
# Targets
#
.PHONY: container
container: DOCKER_BUILD_EXTRA ?=
container: TAG ?= latest
ifeq ($(TARGET),devenv)
container: TARGET ?= devenv
else
container: TARGET ?= latest
endif
container:
	$(DOCKER) build \
		--file $(WORKDIR)/Dockerfile \
		--target $(TARGET) \
		--tag $(IMAGE):$(TAG) \
		--cache-from $(IMAGE):devenv \
			$(WORKDIR)

.PHONY: devenv
devenv:
	$(DOCKER) run -it --rm \
		-p 1313:1313 \
		--volume $(WORKDIR):/usr/src/docs \
		--entrypoint bash \
		$(IMAGE):devenv