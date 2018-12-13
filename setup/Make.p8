#HEADER
#  -- High Performance Conjugate Gradient Benchmark (HPCG)
#     HPCG - 1.1 - November 26, 2013

#     Michael A. Heroux
#     Scalable Algorithms Group, Computing Research Division
#     Sandia National Laboratories, Albuquerque, NM
#
#     Piotr Luszczek
#     Jack Dongarra
#     University of Tennessee, Knoxville
#     Innovative Computing Laboratory
#
#     (C) Copyright 2013 All Rights Reserved
#
#
#  -- Copyright notice and Licensing terms:
#
#  Redistribution  and  use in  source and binary forms, with or without
#  modification, are  permitted provided  that the following  conditions
#  are met:
#
#  1. Redistributions  of  source  code  must retain the above copyright
#  notice, this list of conditions and the following disclaimer.
#
#  2. Redistributions in binary form must reproduce  the above copyright
#  notice, this list of conditions,  and the following disclaimer in the
#  documentation and/or other materials provided with the distribution.
#
#  3. All  advertising  materials  mentioning  features  or  use of this
#  software must display the following acknowledgement:
#  This  product  includes  software  developed  at Sandia National
#  Laboratories, Albuquerque, NM and the  University  of
#  Tennessee, Knoxville, Innovative Computing Laboratory.
#
#  4. The name of the  University,  the name of the  Laboratory,  or the
#  names  of  its  contributors  may  not  be used to endorse or promote
#  products  derived   from   this  software  without  specific  written
#  permission.
#
#  -- Disclaimer:
#
#  THIS  SOFTWARE  IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,  INCLUDING,  BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY
#  OR  CONTRIBUTORS  BE  LIABLE FOR ANY  DIRECT,  INDIRECT,  INCIDENTAL,
#  SPECIAL,  EXEMPLARY,  OR  CONSEQUENTIAL DAMAGES  (INCLUDING,  BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY,  OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ######################################################################
#@HEADER
# ----------------------------------------------------------------------
# - shell --------------------------------------------------------------
# ----------------------------------------------------------------------
#
SHELL        = /bin/sh
#
CD           = cd
CP           = cp
LN_S         = ln -s -f
MKDIR        = mkdir -p
RM           = /bin/rm -f
TOUCH        = touch
#
# ----------------------------------------------------------------------
# - HPCG Directory Structure / HPCG library ------------------------------
# ----------------------------------------------------------------------
#
TOPdir       = .
SRCdir       = $(TOPdir)/src
INCdir       = $(TOPdir)/src
BINdir       = $(TOPdir)/bin
#
# ----------------------------------------------------------------------
# - Message Passing library (MPI) --------------------------------------
# ----------------------------------------------------------------------
# MPinc tells the  C  compiler where to find the Message Passing library
# header files,  MPlib  is defined  to be the name of  the library to be
# used. The variable MPdir is only used for defining MPinc and MPlib.
#
MPdir        =
MPinc        =
MPlib        =
#
#
# ----------------------------------------------------------------------
# - HPCG includes / libraries / specifics -------------------------------
# ----------------------------------------------------------------------
#
HPCG_INCLUDES = -I$(INCdir) -I$(INCdir)/$(arch) $(MPinc)
HPCG_LIBS     =
#
# - Compile time options -----------------------------------------------
#
# -DHPCG_NO_MPI         Define to disable MPI
# -DHPCG_NO_OPENMP	Define to disable OPENMP
# -DHPCG_CONTIGUOUS_ARRAYS Define to have sparse matrix arrays long and contiguous
# -DHPCG_DEBUG          Define to enable debugging output
# -DHPCG_DETAILED_DEBUG Define to enable very detailed debugging output
#
# By default HPCG will:
#    *) Build with MPI enabled.
#    *) Build with OpenMP enabled.
#    *) Not generate debugging output.
#
HPCG_OPTS     =
#
# ----------------------------------------------------------------------
#
HPCG_DEFS     = $(HPCG_OPTS) $(HPCG_INCLUDES)
#
# ----------------------------------------------------------------------
# - IBM includes / libraries / specifics -------------------------------
# ----------------------------------------------------------------------
MASS_VERSION = 9.1.0
MASS_INCLUDE = -I/opt/ibm/xlmass/${MASS_VERSION}/include
MASS_LIB = -L/opt/ibm/xlmass/${MASS_VERSION}/lib -lmassvp8 -lmass_simdp8 -lmass

# ----------------------------------------------------------------------
# - Compilers / linkers - Optimization flags ---------------------------
# ----------------------------------------------------------------------
#
CXX          = mpic++
CXXFLAGS     = $(HPCG_DEFS) $(MASS_INCLUDE) \
               -O5 -qmaxmem=-1 -qalign=linuxppc -qnostrict \
               -qhot=level=2 -qipa=level=2 -qinline \
               -qsmp=omp -qthreaded \
               -qsimd -qaltivec \
               -q64 -qarch=pwr8 -qtune=pwr8
#
LINKER       = $(CXX)
LINKFLAGS    = $(CXXFLAGS) $(MASS_LIB)
#
ARCHIVER     = ar
ARFLAGS      = r
RANLIB       = echo
#
# ----------------------------------------------------------------------