pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with driver_types_h;
with stddef_h;
with Interfaces.C.Strings;
with System;
with vector_types_h;
with texture_types_h;
with surface_types_h;

package cuda_runtime_api_h is

   CUDART_VERSION : constant := 8000;  --  /usr/local/cuda-8.0/include/cuda_runtime_api.h:131
   --  unsupported macro: CUDART_DEVICE __device__

  -- * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
  -- *
  -- * NOTICE TO LICENSEE:
  -- *
  -- * This source code and/or documentation ("Licensed Deliverables") are
  -- * subject to NVIDIA intellectual property rights under U.S. and
  -- * international Copyright laws.
  -- *
  -- * These Licensed Deliverables contained herein is PROPRIETARY and
  -- * CONFIDENTIAL to NVIDIA and is being provided under the terms and
  -- * conditions of a form of NVIDIA software license agreement by and
  -- * between NVIDIA and Licensee ("License Agreement") or electronically
  -- * accepted by Licensee.  Notwithstanding any terms or conditions to
  -- * the contrary in the License Agreement, reproduction or disclosure
  -- * of the Licensed Deliverables to any third party without the express
  -- * written consent of NVIDIA is prohibited.
  -- *
  -- * NOTWITHSTANDING ANY TERMS OR CONDITIONS TO THE CONTRARY IN THE
  -- * LICENSE AGREEMENT, NVIDIA MAKES NO REPRESENTATION ABOUT THE
  -- * SUITABILITY OF THESE LICENSED DELIVERABLES FOR ANY PURPOSE.  IT IS
  -- * PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF ANY KIND.
  -- * NVIDIA DISCLAIMS ALL WARRANTIES WITH REGARD TO THESE LICENSED
  -- * DELIVERABLES, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY,
  -- * NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE.
  -- * NOTWITHSTANDING ANY TERMS OR CONDITIONS TO THE CONTRARY IN THE
  -- * LICENSE AGREEMENT, IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY
  -- * SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, OR ANY
  -- * DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
  -- * WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
  -- * ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
  -- * OF THESE LICENSED DELIVERABLES.
  -- *
  -- * U.S. Government End Users.  These Licensed Deliverables are a
  -- * "commercial item" as that term is defined at 48 C.F.R. 2.101 (OCT
  -- * 1995), consisting of "commercial computer software" and "commercial
  -- * computer software documentation" as such terms are used in 48
  -- * C.F.R. 12.212 (SEPT 1995) and is provided to the U.S. Government
  -- * only as a commercial end item.  Consistent with 48 C.F.R.12.212 and
  -- * 48 C.F.R. 227.7202-1 through 227.7202-4 (JUNE 1995), all
  -- * U.S. Government End Users acquire the Licensed Deliverables with
  -- * only those rights set forth herein.
  -- *
  -- * Any use of the Licensed Deliverables in individual and commercial
  -- * software must include, in the user documentation and internal
  -- * comments to the code, the above Disclaimer and U.S. Government End
  -- * Users Notice.
  --  

  --*
  -- * \latexonly
  -- * \page sync_async API synchronization behavior
  -- *
  -- * \section memcpy_sync_async_behavior Memcpy
  -- * The API provides memcpy/memset functions in both synchronous and asynchronous forms,
  -- * the latter having an \e "Async" suffix. This is a misnomer as each function
  -- * may exhibit synchronous or asynchronous behavior depending on the arguments
  -- * passed to the function. In the reference documentation, each memcpy function is
  -- * categorized as \e synchronous or \e asynchronous, corresponding to the definitions
  -- * below.
  -- * 
  -- * \subsection MemcpySynchronousBehavior Synchronous
  -- * 
  -- * <ol>
  -- * <li> For transfers from pageable host memory to device memory, a stream sync is performed
  -- * before the copy is initiated. The function will return once the pageable
  -- * buffer has been copied to the staging memory for DMA transfer to device memory,
  -- * but the DMA to final destination may not have completed.
  -- * 
  -- * <li> For transfers from pinned host memory to device memory, the function is synchronous
  -- * with respect to the host.
  -- *
  -- * <li> For transfers from device to either pageable or pinned host memory, the function returns
  -- * only once the copy has completed.
  -- * 
  -- * <li> For transfers from device memory to device memory, no host-side synchronization is
  -- * performed.
  -- *
  -- * <li> For transfers from any host memory to any host memory, the function is fully
  -- * synchronous with respect to the host.
  -- * </ol>
  -- * 
  -- * \subsection MemcpyAsynchronousBehavior Asynchronous
  -- *
  -- * <ol>
  -- * <li> For transfers from device memory to pageable host memory, the function
  -- * will return only once the copy has completed.
  -- *
  -- * <li> For transfers from any host memory to any host memory, the function is fully
  -- * synchronous with respect to the host.
  -- * 
  -- * <li> For all other transfers, the function is fully asynchronous. If pageable
  -- * memory must first be staged to pinned memory, this will be handled
  -- * asynchronously with a worker thread.
  -- * </ol>
  -- *
  -- * \section memset_sync_async_behavior Memset
  -- * The cudaMemset functions are asynchronous with respect to the host
  -- * except when the target memory is pinned host memory. The \e Async
  -- * versions are always asynchronous with respect to the host.
  -- *
  -- * \section kernel_launch_details Kernel Launches
  -- * Kernel launches are asynchronous with respect to the host. Details of
  -- * concurrent kernel execution and data transfers can be found in the CUDA
  -- * Programmers Guide.
  -- *
  -- * \endlatexonly
  --  

  --*
  -- * There are two levels for the runtime API.
  -- *
  -- * The C API (<i>cuda_runtime_api.h</i>) is
  -- * a C-style interface that does not require compiling with \p nvcc.
  -- *
  -- * The \ref CUDART_HIGHLEVEL "C++ API" (<i>cuda_runtime.h</i>) is a
  -- * C++-style interface built on top of the C API. It wraps some of the
  -- * C API routines, using overloading, references and default arguments.
  -- * These wrappers can be used from C++ code and can be compiled with any C++
  -- * compiler. The C++ API also has some CUDA-specific wrappers that wrap
  -- * C API routines that deal with symbols, textures, and device functions.
  -- * These wrappers require the use of \p nvcc because they depend on code being
  -- * generated by the compiler. For example, the execution configuration syntax
  -- * to invoke kernels is only available in source code compiled with \p nvcc.
  --  

  --* CUDA Runtime API Version  
  --* \cond impl_private  
  --* \endcond impl_private  
  --*
  -- * \defgroup CUDART_DEVICE Device Management
  -- *
  -- * ___MANBRIEF___ device management functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the device management functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Destroy all allocations and reset all state on the current device
  -- * in the current process.
  -- *
  -- * Explicitly destroys and cleans up all resources associated with the current
  -- * device in the current process.  Any subsequent API call to this device will 
  -- * reinitialize the device.
  -- *
  -- * Note that this function will reset the device immediately.  It is the caller's
  -- * responsibility to ensure that the device is not being accessed by any 
  -- * other host threads from the process when this function is called.
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceSynchronize
  --  

   function cudaDeviceReset return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:252
   pragma Import (C, cudaDeviceReset, "cudaDeviceReset");

  --*
  -- * \brief Wait for compute device to finish
  -- *
  -- * Blocks until the device has completed all preceding requested tasks.
  -- * ::cudaDeviceSynchronize() returns an error if one of the preceding tasks
  -- * has failed. If the ::cudaDeviceScheduleBlockingSync flag was set for 
  -- * this device, the host thread will block until the device has finished 
  -- * its work.
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceReset
  --  

   function cudaDeviceSynchronize return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:269
   pragma Import (C, cudaDeviceSynchronize, "cudaDeviceSynchronize");

  --*
  -- * \brief Set resource limits
  -- *
  -- * Setting \p limit to \p value is a request by the application to update
  -- * the current limit maintained by the device.  The driver is free to
  -- * modify the requested value to meet h/w requirements (this could be
  -- * clamping to minimum or maximum values, rounding up to nearest element
  -- * size, etc).  The application can use ::cudaDeviceGetLimit() to find out
  -- * exactly what the limit has been set to.
  -- *
  -- * Setting each ::cudaLimit has its own specific restrictions, so each is
  -- * discussed here.
  -- *
  -- * - ::cudaLimitStackSize controls the stack size in bytes of each GPU thread.
  -- *
  -- * - ::cudaLimitPrintfFifoSize controls the size in bytes of the shared FIFO
  -- *   used by the ::printf() and ::fprintf() device system calls. Setting
  -- *   ::cudaLimitPrintfFifoSize must not be performed after launching any kernel
  -- *   that uses the ::printf() or ::fprintf() device system calls - in such case
  -- *   ::cudaErrorInvalidValue will be returned.
  -- *
  -- * - ::cudaLimitMallocHeapSize controls the size in bytes of the heap used by
  -- *   the ::malloc() and ::free() device system calls. Setting
  -- *   ::cudaLimitMallocHeapSize must not be performed after launching any kernel
  -- *   that uses the ::malloc() or ::free() device system calls - in such case
  -- *   ::cudaErrorInvalidValue will be returned.
  -- *
  -- * - ::cudaLimitDevRuntimeSyncDepth controls the maximum nesting depth of a
  -- *   grid at which a thread can safely call ::cudaDeviceSynchronize(). Setting
  -- *   this limit must be performed before any launch of a kernel that uses the
  -- *   device runtime and calls ::cudaDeviceSynchronize() above the default sync
  -- *   depth, two levels of grids. Calls to ::cudaDeviceSynchronize() will fail
  -- *   with error code ::cudaErrorSyncDepthExceeded if the limitation is
  -- *   violated. This limit can be set smaller than the default or up the maximum
  -- *   launch depth of 24. When setting this limit, keep in mind that additional
  -- *   levels of sync depth require the runtime to reserve large amounts of
  -- *   device memory which can no longer be used for user allocations. If these
  -- *   reservations of device memory fail, ::cudaDeviceSetLimit will return
  -- *   ::cudaErrorMemoryAllocation, and the limit can be reset to a lower value.
  -- *   This limit is only applicable to devices of compute capability 3.5 and
  -- *   higher. Attempting to set this limit on devices of compute capability less
  -- *   than 3.5 will result in the error ::cudaErrorUnsupportedLimit being
  -- *   returned.
  -- *
  -- * - ::cudaLimitDevRuntimePendingLaunchCount controls the maximum number of
  -- *   outstanding device runtime launches that can be made from the current
  -- *   device. A grid is outstanding from the point of launch up until the grid
  -- *   is known to have been completed. Device runtime launches which violate 
  -- *   this limitation fail and return ::cudaErrorLaunchPendingCountExceeded when
  -- *   ::cudaGetLastError() is called after launch. If more pending launches than
  -- *   the default (2048 launches) are needed for a module using the device
  -- *   runtime, this limit can be increased. Keep in mind that being able to
  -- *   sustain additional pending launches will require the runtime to reserve
  -- *   larger amounts of device memory upfront which can no longer be used for
  -- *   allocations. If these reservations fail, ::cudaDeviceSetLimit will return
  -- *   ::cudaErrorMemoryAllocation, and the limit can be reset to a lower value.
  -- *   This limit is only applicable to devices of compute capability 3.5 and
  -- *   higher. Attempting to set this limit on devices of compute capability less
  -- *   than 3.5 will result in the error ::cudaErrorUnsupportedLimit being
  -- *   returned. 
  -- *
  -- * \param limit - Limit to set
  -- * \param value - Size of limit
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorUnsupportedLimit,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceGetLimit
  --  

   function cudaDeviceSetLimit (limit : driver_types_h.cudaLimit; value : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:344
   pragma Import (C, cudaDeviceSetLimit, "cudaDeviceSetLimit");

  --*
  -- * \brief Returns resource limits
  -- *
  -- * Returns in \p *pValue the current size of \p limit.  The supported
  -- * ::cudaLimit values are:
  -- * - ::cudaLimitStackSize: stack size in bytes of each GPU thread;
  -- * - ::cudaLimitPrintfFifoSize: size in bytes of the shared FIFO used by the
  -- *   ::printf() and ::fprintf() device system calls.
  -- * - ::cudaLimitMallocHeapSize: size in bytes of the heap used by the
  -- *   ::malloc() and ::free() device system calls;
  -- * - ::cudaLimitDevRuntimeSyncDepth: maximum grid depth at which a
  -- *   thread can isssue the device runtime call ::cudaDeviceSynchronize()
  -- *   to wait on child grid launches to complete.
  -- * - ::cudaLimitDevRuntimePendingLaunchCount: maximum number of outstanding
  -- *   device runtime launches.
  -- *
  -- * \param limit  - Limit to query
  -- * \param pValue - Returned size of the limit
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorUnsupportedLimit,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceSetLimit
  --  

   function cudaDeviceGetLimit (pValue : access stddef_h.size_t; limit : driver_types_h.cudaLimit) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:373
   pragma Import (C, cudaDeviceGetLimit, "cudaDeviceGetLimit");

  --*
  -- * \brief Returns the preferred cache configuration for the current device.
  -- *
  -- * On devices where the L1 cache and shared memory use the same hardware
  -- * resources, this returns through \p pCacheConfig the preferred cache
  -- * configuration for the current device. This is only a preference. The
  -- * runtime will use the requested configuration if possible, but it is free to
  -- * choose a different configuration if required to execute functions.
  -- *
  -- * This will return a \p pCacheConfig of ::cudaFuncCachePreferNone on devices
  -- * where the size of the L1 cache and shared memory are fixed.
  -- *
  -- * The supported cache configurations are:
  -- * - ::cudaFuncCachePreferNone: no preference for shared memory or L1 (default)
  -- * - ::cudaFuncCachePreferShared: prefer larger shared memory and smaller L1 cache
  -- * - ::cudaFuncCachePreferL1: prefer larger L1 cache and smaller shared memory
  -- * - ::cudaFuncCachePreferEqual: prefer equal size L1 cache and shared memory
  -- *
  -- * \param pCacheConfig - Returned cache configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa cudaDeviceSetCacheConfig,
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncSetCacheConfig(T*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C++ API)"
  --  

   function cudaDeviceGetCacheConfig (pCacheConfig : access driver_types_h.cudaFuncCache) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:404
   pragma Import (C, cudaDeviceGetCacheConfig, "cudaDeviceGetCacheConfig");

  --*
  -- * \brief Returns numerical values that correspond to the least and
  -- * greatest stream priorities.
  -- *
  -- * Returns in \p *leastPriority and \p *greatestPriority the numerical values that correspond
  -- * to the least and greatest stream priorities respectively. Stream priorities
  -- * follow a convention where lower numbers imply greater priorities. The range of
  -- * meaningful stream priorities is given by [\p *greatestPriority, \p *leastPriority].
  -- * If the user attempts to create a stream with a priority value that is
  -- * outside the the meaningful range as specified by this API, the priority is
  -- * automatically clamped down or up to either \p *leastPriority or \p *greatestPriority
  -- * respectively. See ::cudaStreamCreateWithPriority for details on creating a
  -- * priority stream.
  -- * A NULL may be passed in for \p *leastPriority or \p *greatestPriority if the value
  -- * is not desired.
  -- *
  -- * This function will return '0' in both \p *leastPriority and \p *greatestPriority if
  -- * the current context's device does not support stream priorities
  -- * (see ::cudaDeviceGetAttribute).
  -- *
  -- * \param leastPriority    - Pointer to an int in which the numerical value for least
  -- *                           stream priority is returned
  -- * \param greatestPriority - Pointer to an int in which the numerical value for greatest
  -- *                           stream priority is returned
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreateWithPriority,
  -- * ::cudaStreamGetPriority
  --  

   function cudaDeviceGetStreamPriorityRange (leastPriority : access int; greatestPriority : access int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:439
   pragma Import (C, cudaDeviceGetStreamPriorityRange, "cudaDeviceGetStreamPriorityRange");

  --*
  -- * \brief Sets the preferred cache configuration for the current device.
  -- *
  -- * On devices where the L1 cache and shared memory use the same hardware
  -- * resources, this sets through \p cacheConfig the preferred cache
  -- * configuration for the current device. This is only a preference. The
  -- * runtime will use the requested configuration if possible, but it is free to
  -- * choose a different configuration if required to execute the function. Any
  -- * function preference set via
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)"
  -- * or
  -- * \ref ::cudaFuncSetCacheConfig(T*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C++ API)"
  -- * will be preferred over this device-wide setting. Setting the device-wide
  -- * cache configuration to ::cudaFuncCachePreferNone will cause subsequent
  -- * kernel launches to prefer to not change the cache configuration unless
  -- * required to launch the kernel.
  -- *
  -- * This setting does nothing on devices where the size of the L1 cache and
  -- * shared memory are fixed.
  -- *
  -- * Launching a kernel with a different preference than the most recent
  -- * preference setting may insert a device-side synchronization point.
  -- *
  -- * The supported cache configurations are:
  -- * - ::cudaFuncCachePreferNone: no preference for shared memory or L1 (default)
  -- * - ::cudaFuncCachePreferShared: prefer larger shared memory and smaller L1 cache
  -- * - ::cudaFuncCachePreferL1: prefer larger L1 cache and smaller shared memory
  -- * - ::cudaFuncCachePreferEqual: prefer equal size L1 cache and shared memory
  -- *
  -- * \param cacheConfig - Requested cache configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceGetCacheConfig,
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncSetCacheConfig(T*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C++ API)"
  --  

   function cudaDeviceSetCacheConfig (cacheConfig : driver_types_h.cudaFuncCache) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:481
   pragma Import (C, cudaDeviceSetCacheConfig, "cudaDeviceSetCacheConfig");

  --*
  -- * \brief Returns the shared memory configuration for the current device.
  -- *
  -- * This function will return in \p pConfig the current size of shared memory banks
  -- * on the current device. On devices with configurable shared memory banks, 
  -- * ::cudaDeviceSetSharedMemConfig can be used to change this setting, so that all 
  -- * subsequent kernel launches will by default use the new bank size. When 
  -- * ::cudaDeviceGetSharedMemConfig is called on devices without configurable shared 
  -- * memory, it will return the fixed bank size of the hardware.
  -- *
  -- * The returned bank configurations can be either:
  -- * - ::cudaSharedMemBankSizeFourByte - shared memory bank width is four bytes.
  -- * - ::cudaSharedMemBankSizeEightByte - shared memory bank width is eight bytes.
  -- *
  -- * \param pConfig - Returned cache configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceSetCacheConfig,
  -- * ::cudaDeviceGetCacheConfig,
  -- * ::cudaDeviceSetSharedMemConfig,
  -- * ::cudaFuncSetCacheConfig
  --  

   function cudaDeviceGetSharedMemConfig (pConfig : access driver_types_h.cudaSharedMemConfig) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:510
   pragma Import (C, cudaDeviceGetSharedMemConfig, "cudaDeviceGetSharedMemConfig");

  --*
  -- * \brief Sets the shared memory configuration for the current device.
  -- *
  -- * On devices with configurable shared memory banks, this function will set
  -- * the shared memory bank size which is used for all subsequent kernel launches.
  -- * Any per-function setting of shared memory set via ::cudaFuncSetSharedMemConfig
  -- * will override the device wide setting.
  -- *
  -- * Changing the shared memory configuration between launches may introduce
  -- * a device side synchronization point.
  -- *
  -- * Changing the shared memory bank size will not increase shared memory usage
  -- * or affect occupancy of kernels, but may have major effects on performance. 
  -- * Larger bank sizes will allow for greater potential bandwidth to shared memory,
  -- * but will change what kinds of accesses to shared memory will result in bank 
  -- * conflicts.
  -- *
  -- * This function will do nothing on devices with fixed shared memory bank size.
  -- *
  -- * The supported bank configurations are:
  -- * - ::cudaSharedMemBankSizeDefault: set bank width the device default (currently,
  -- *   four bytes)
  -- * - ::cudaSharedMemBankSizeFourByte: set shared memory bank width to be four bytes
  -- *   natively.
  -- * - ::cudaSharedMemBankSizeEightByte: set shared memory bank width to be eight 
  -- *   bytes natively.
  -- *
  -- * \param config - Requested cache configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceSetCacheConfig,
  -- * ::cudaDeviceGetCacheConfig,
  -- * ::cudaDeviceGetSharedMemConfig,
  -- * ::cudaFuncSetCacheConfig
  --  

   function cudaDeviceSetSharedMemConfig (config : driver_types_h.cudaSharedMemConfig) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:552
   pragma Import (C, cudaDeviceSetSharedMemConfig, "cudaDeviceSetSharedMemConfig");

  --*
  -- * \brief Returns a handle to a compute device
  -- *
  -- * Returns in \p *device a device ordinal given a PCI bus ID string.
  -- *
  -- * \param device   - Returned device ordinal
  -- *
  -- * \param pciBusId - String in one of the following forms: 
  -- * [domain]:[bus]:[device].[function]
  -- * [domain]:[bus]:[device]
  -- * [bus]:[device].[function]
  -- * where \p domain, \p bus, \p device, and \p function are all hexadecimal values
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceGetPCIBusId
  --  

   function cudaDeviceGetByPCIBusId (device : access int; pciBusId : Interfaces.C.Strings.chars_ptr) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:575
   pragma Import (C, cudaDeviceGetByPCIBusId, "cudaDeviceGetByPCIBusId");

  --*
  -- * \brief Returns a PCI Bus Id string for the device
  -- *
  -- * Returns an ASCII string identifying the device \p dev in the NULL-terminated
  -- * string pointed to by \p pciBusId. \p len specifies the maximum length of the
  -- * string that may be returned.
  -- *
  -- * \param pciBusId - Returned identifier string for the device in the following format
  -- * [domain]:[bus]:[device].[function]
  -- * where \p domain, \p bus, \p device, and \p function are all hexadecimal values.
  -- * pciBusId should be large enough to store 13 characters including the NULL-terminator.
  -- *
  -- * \param len      - Maximum length of string to store in \p name
  -- *
  -- * \param device   - Device to get identifier string for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceGetByPCIBusId
  --  

   function cudaDeviceGetPCIBusId
     (pciBusId : Interfaces.C.Strings.chars_ptr;
      len : int;
      device : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:602
   pragma Import (C, cudaDeviceGetPCIBusId, "cudaDeviceGetPCIBusId");

  --*
  -- * \brief Gets an interprocess handle for a previously allocated event
  -- *
  -- * Takes as input a previously allocated event. This event must have been 
  -- * created with the ::cudaEventInterprocess and ::cudaEventDisableTiming
  -- * flags set. This opaque handle may be copied into other processes and
  -- * opened with ::cudaIpcOpenEventHandle to allow efficient hardware
  -- * synchronization between GPU work in different processes.
  -- *
  -- * After the event has been been opened in the importing process, 
  -- * ::cudaEventRecord, ::cudaEventSynchronize, ::cudaStreamWaitEvent and 
  -- * ::cudaEventQuery may be used in either process. Performing operations 
  -- * on the imported event after the exported event has been freed 
  -- * with ::cudaEventDestroy will result in undefined behavior.
  -- *
  -- * IPC functionality is restricted to devices with support for unified 
  -- * addressing on Linux operating systems.
  -- *
  -- * \param handle - Pointer to a user allocated cudaIpcEventHandle
  -- *                    in which to return the opaque event handle
  -- * \param event   - Event allocated with ::cudaEventInterprocess and 
  -- *                    ::cudaEventDisableTiming flags.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorMemoryAllocation,
  -- * ::cudaErrorMapBufferObjectFailed
  -- *
  -- * \sa
  -- * ::cudaEventCreate,
  -- * ::cudaEventDestroy,
  -- * ::cudaEventSynchronize,
  -- * ::cudaEventQuery,
  -- * ::cudaStreamWaitEvent,
  -- * ::cudaIpcOpenEventHandle,
  -- * ::cudaIpcGetMemHandle,
  -- * ::cudaIpcOpenMemHandle,
  -- * ::cudaIpcCloseMemHandle
  --  

   function cudaIpcGetEventHandle (handle : access driver_types_h.cudaIpcEventHandle_t; event : driver_types_h.cudaEvent_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:644
   pragma Import (C, cudaIpcGetEventHandle, "cudaIpcGetEventHandle");

  --*
  -- * \brief Opens an interprocess event handle for use in the current process
  -- *
  -- * Opens an interprocess event handle exported from another process with 
  -- * ::cudaIpcGetEventHandle. This function returns a ::cudaEvent_t that behaves like 
  -- * a locally created event with the ::cudaEventDisableTiming flag specified. 
  -- * This event must be freed with ::cudaEventDestroy.
  -- *
  -- * Performing operations on the imported event after the exported event has 
  -- * been freed with ::cudaEventDestroy will result in undefined behavior.
  -- *
  -- * IPC functionality is restricted to devices with support for unified 
  -- * addressing on Linux operating systems.
  -- *
  -- * \param event - Returns the imported event
  -- * \param handle  - Interprocess handle to open
  -- *
  -- * \returns
  -- * ::cudaSuccess,
  -- * ::cudaErrorMapBufferObjectFailed,
  -- * ::cudaErrorInvalidResourceHandle
  -- *
  --  * \sa
  -- * ::cudaEventCreate,
  -- * ::cudaEventDestroy,
  -- * ::cudaEventSynchronize,
  -- * ::cudaEventQuery,
  -- * ::cudaStreamWaitEvent,
  -- * ::cudaIpcGetEventHandle,
  -- * ::cudaIpcGetMemHandle,
  -- * ::cudaIpcOpenMemHandle,
  -- * ::cudaIpcCloseMemHandle
  --  

   function cudaIpcOpenEventHandle (event : System.Address; handle : driver_types_h.cudaIpcEventHandle_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:679
   pragma Import (C, cudaIpcOpenEventHandle, "cudaIpcOpenEventHandle");

  --*
  -- * \brief Gets an interprocess memory handle for an existing device memory
  -- *          allocation
  -- *
  -- * Takes a pointer to the base of an existing device memory allocation created 
  -- * with ::cudaMalloc and exports it for use in another process. This is a 
  -- * lightweight operation and may be called multiple times on an allocation
  -- * without adverse effects. 
  -- *
  -- * If a region of memory is freed with ::cudaFree and a subsequent call
  -- * to ::cudaMalloc returns memory with the same device address,
  -- * ::cudaIpcGetMemHandle will return a unique handle for the
  -- * new memory. 
  -- *
  -- * IPC functionality is restricted to devices with support for unified 
  -- * addressing on Linux operating systems.
  -- *
  -- * \param handle - Pointer to user allocated ::cudaIpcMemHandle to return
  -- *                    the handle in.
  -- * \param devPtr - Base pointer to previously allocated device memory 
  -- *
  -- * \returns
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorMemoryAllocation,
  -- * ::cudaErrorMapBufferObjectFailed,
  -- *
  -- * \sa
  -- * ::cudaMalloc,
  -- * ::cudaFree,
  -- * ::cudaIpcGetEventHandle,
  -- * ::cudaIpcOpenEventHandle,
  -- * ::cudaIpcOpenMemHandle,
  -- * ::cudaIpcCloseMemHandle
  --  

   function cudaIpcGetMemHandle (handle : access driver_types_h.cudaIpcMemHandle_t; devPtr : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:717
   pragma Import (C, cudaIpcGetMemHandle, "cudaIpcGetMemHandle");

  --*
  -- * \brief Opens an interprocess memory handle exported from another process
  -- *          and returns a device pointer usable in the local process.
  -- *
  -- * Maps memory exported from another process with ::cudaIpcGetMemHandle into
  -- * the current device address space. For contexts on different devices 
  -- * ::cudaIpcOpenMemHandle can attempt to enable peer access between the
  -- * devices as if the user called ::cudaDeviceEnablePeerAccess. This behavior is 
  -- * controlled by the ::cudaIpcMemLazyEnablePeerAccess flag. 
  -- * ::cudaDeviceCanAccessPeer can determine if a mapping is possible.
  -- *
  -- * Contexts that may open ::cudaIpcMemHandles are restricted in the following way.
  -- * ::cudaIpcMemHandles from each device in a given process may only be opened 
  -- * by one context per device per other process.
  -- *
  -- * Memory returned from ::cudaIpcOpenMemHandle must be freed with
  -- * ::cudaIpcCloseMemHandle.
  -- *
  -- * Calling ::cudaFree on an exported memory region before calling
  -- * ::cudaIpcCloseMemHandle in the importing context will result in undefined
  -- * behavior.
  -- * 
  -- * IPC functionality is restricted to devices with support for unified 
  -- * addressing on Linux operating systems.
  -- *
  -- * \param devPtr - Returned device pointer
  -- * \param handle - ::cudaIpcMemHandle to open
  -- * \param flags  - Flags for this operation. Must be specified as ::cudaIpcMemLazyEnablePeerAccess
  -- *
  -- * \returns
  -- * ::cudaSuccess,
  -- * ::cudaErrorMapBufferObjectFailed,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorTooManyPeers
  -- *
  -- * \note No guarantees are made about the address returned in \p *devPtr.  
  -- * In particular, multiple processes may not receive the same address for the same \p handle.
  -- *
  -- * \sa
  -- * ::cudaMalloc,
  -- * ::cudaFree,
  -- * ::cudaIpcGetEventHandle,
  -- * ::cudaIpcOpenEventHandle,
  -- * ::cudaIpcGetMemHandle,
  -- * ::cudaIpcCloseMemHandle,
  -- * ::cudaDeviceEnablePeerAccess,
  -- * ::cudaDeviceCanAccessPeer,
  --  

   function cudaIpcOpenMemHandle
     (devPtr : System.Address;
      handle : driver_types_h.cudaIpcMemHandle_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:767
   pragma Import (C, cudaIpcOpenMemHandle, "cudaIpcOpenMemHandle");

  --*
  -- * \brief Close memory mapped with cudaIpcOpenMemHandle
  -- * 
  -- * Unmaps memory returnd by ::cudaIpcOpenMemHandle. The original allocation
  -- * in the exporting process as well as imported mappings in other processes
  -- * will be unaffected.
  -- *
  -- * Any resources used to enable peer access will be freed if this is the
  -- * last mapping using them.
  -- *
  -- * IPC functionality is restricted to devices with support for unified 
  -- * addressing on Linux operating systems.
  -- *
  -- * \param devPtr - Device pointer returned by ::cudaIpcOpenMemHandle
  -- * 
  -- * \returns
  -- * ::cudaSuccess,
  -- * ::cudaErrorMapBufferObjectFailed,
  -- * ::cudaErrorInvalidResourceHandle,
  -- *
  -- * \sa
  -- * ::cudaMalloc,
  -- * ::cudaFree,
  -- * ::cudaIpcGetEventHandle,
  -- * ::cudaIpcOpenEventHandle,
  -- * ::cudaIpcGetMemHandle,
  -- * ::cudaIpcOpenMemHandle,
  --  

   function cudaIpcCloseMemHandle (devPtr : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:797
   pragma Import (C, cudaIpcCloseMemHandle, "cudaIpcCloseMemHandle");

  --* @}  
  -- END CUDART_DEVICE  
  --*
  -- * \defgroup CUDART_THREAD_DEPRECATED Thread Management [DEPRECATED]
  -- *
  -- * ___MANBRIEF___ deprecated thread management functions of the CUDA runtime
  -- * API (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes deprecated thread management functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Exit and clean up from CUDA launches
  -- *
  -- * \deprecated
  -- *
  -- * Note that this function is deprecated because its name does not 
  -- * reflect its behavior.  Its functionality is identical to the 
  -- * non-deprecated function ::cudaDeviceReset(), which should be used
  -- * instead.
  -- *
  -- * Explicitly destroys all cleans up all resources associated with the current
  -- * device in the current process.  Any subsequent API call to this device will 
  -- * reinitialize the device.  
  -- *
  -- * Note that this function will reset the device immediately.  It is the caller's
  -- * responsibility to ensure that the device is not being accessed by any 
  -- * other host threads from the process when this function is called.
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceReset
  --  

   function cudaThreadExit return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:837
   pragma Import (C, cudaThreadExit, "cudaThreadExit");

  --*
  -- * \brief Wait for compute device to finish
  -- *
  -- * \deprecated
  -- *
  -- * Note that this function is deprecated because its name does not 
  -- * reflect its behavior.  Its functionality is similar to the 
  -- * non-deprecated function ::cudaDeviceSynchronize(), which should be used
  -- * instead.
  -- *
  -- * Blocks until the device has completed all preceding requested tasks.
  -- * ::cudaThreadSynchronize() returns an error if one of the preceding tasks
  -- * has failed. If the ::cudaDeviceScheduleBlockingSync flag was set for 
  -- * this device, the host thread will block until the device has finished 
  -- * its work.
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceSynchronize
  --  

   function cudaThreadSynchronize return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:861
   pragma Import (C, cudaThreadSynchronize, "cudaThreadSynchronize");

  --*
  -- * \brief Set resource limits
  -- *
  -- * \deprecated
  -- *
  -- * Note that this function is deprecated because its name does not 
  -- * reflect its behavior.  Its functionality is identical to the 
  -- * non-deprecated function ::cudaDeviceSetLimit(), which should be used
  -- * instead.
  -- *
  -- * Setting \p limit to \p value is a request by the application to update
  -- * the current limit maintained by the device.  The driver is free to
  -- * modify the requested value to meet h/w requirements (this could be
  -- * clamping to minimum or maximum values, rounding up to nearest element
  -- * size, etc).  The application can use ::cudaThreadGetLimit() to find out
  -- * exactly what the limit has been set to.
  -- *
  -- * Setting each ::cudaLimit has its own specific restrictions, so each is
  -- * discussed here.
  -- *
  -- * - ::cudaLimitStackSize controls the stack size of each GPU thread.
  -- *
  -- * - ::cudaLimitPrintfFifoSize controls the size of the shared FIFO
  -- *   used by the ::printf() and ::fprintf() device system calls.
  -- *   Setting ::cudaLimitPrintfFifoSize must be performed before
  -- *   launching any kernel that uses the ::printf() or ::fprintf() device
  -- *   system calls, otherwise ::cudaErrorInvalidValue will be returned.
  -- *
  -- * - ::cudaLimitMallocHeapSize controls the size of the heap used
  -- *   by the ::malloc() and ::free() device system calls.  Setting
  -- *   ::cudaLimitMallocHeapSize must be performed before launching
  -- *   any kernel that uses the ::malloc() or ::free() device system calls,
  -- *   otherwise ::cudaErrorInvalidValue will be returned.
  -- *
  -- * \param limit - Limit to set
  -- * \param value - Size in bytes of limit
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorUnsupportedLimit,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceSetLimit
  --  

   function cudaThreadSetLimit (limit : driver_types_h.cudaLimit; value : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:908
   pragma Import (C, cudaThreadSetLimit, "cudaThreadSetLimit");

  --*
  -- * \brief Returns resource limits
  -- *
  -- * \deprecated
  -- *
  -- * Note that this function is deprecated because its name does not 
  -- * reflect its behavior.  Its functionality is identical to the 
  -- * non-deprecated function ::cudaDeviceGetLimit(), which should be used
  -- * instead.
  -- *
  -- * Returns in \p *pValue the current size of \p limit.  The supported
  -- * ::cudaLimit values are:
  -- * - ::cudaLimitStackSize: stack size of each GPU thread;
  -- * - ::cudaLimitPrintfFifoSize: size of the shared FIFO used by the
  -- *   ::printf() and ::fprintf() device system calls.
  -- * - ::cudaLimitMallocHeapSize: size of the heap used by the
  -- *   ::malloc() and ::free() device system calls;
  -- *
  -- * \param limit  - Limit to query
  -- * \param pValue - Returned size in bytes of limit
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorUnsupportedLimit,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceGetLimit
  --  

   function cudaThreadGetLimit (pValue : access stddef_h.size_t; limit : driver_types_h.cudaLimit) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:939
   pragma Import (C, cudaThreadGetLimit, "cudaThreadGetLimit");

  --*
  -- * \brief Returns the preferred cache configuration for the current device.
  -- *
  -- * \deprecated
  -- *
  -- * Note that this function is deprecated because its name does not 
  -- * reflect its behavior.  Its functionality is identical to the 
  -- * non-deprecated function ::cudaDeviceGetCacheConfig(), which should be 
  -- * used instead.
  -- * 
  -- * On devices where the L1 cache and shared memory use the same hardware
  -- * resources, this returns through \p pCacheConfig the preferred cache
  -- * configuration for the current device. This is only a preference. The
  -- * runtime will use the requested configuration if possible, but it is free to
  -- * choose a different configuration if required to execute functions.
  -- *
  -- * This will return a \p pCacheConfig of ::cudaFuncCachePreferNone on devices
  -- * where the size of the L1 cache and shared memory are fixed.
  -- *
  -- * The supported cache configurations are:
  -- * - ::cudaFuncCachePreferNone: no preference for shared memory or L1 (default)
  -- * - ::cudaFuncCachePreferShared: prefer larger shared memory and smaller L1 cache
  -- * - ::cudaFuncCachePreferL1: prefer larger L1 cache and smaller shared memory
  -- *
  -- * \param pCacheConfig - Returned cache configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa cudaDeviceGetCacheConfig
  --  

   function cudaThreadGetCacheConfig (pCacheConfig : access driver_types_h.cudaFuncCache) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:974
   pragma Import (C, cudaThreadGetCacheConfig, "cudaThreadGetCacheConfig");

  --*
  -- * \brief Sets the preferred cache configuration for the current device.
  -- *
  -- * \deprecated
  -- *
  -- * Note that this function is deprecated because its name does not 
  -- * reflect its behavior.  Its functionality is identical to the 
  -- * non-deprecated function ::cudaDeviceSetCacheConfig(), which should be 
  -- * used instead.
  -- * 
  -- * On devices where the L1 cache and shared memory use the same hardware
  -- * resources, this sets through \p cacheConfig the preferred cache
  -- * configuration for the current device. This is only a preference. The
  -- * runtime will use the requested configuration if possible, but it is free to
  -- * choose a different configuration if required to execute the function. Any
  -- * function preference set via
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)"
  -- * or
  -- * \ref ::cudaFuncSetCacheConfig(T*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C++ API)"
  -- * will be preferred over this device-wide setting. Setting the device-wide
  -- * cache configuration to ::cudaFuncCachePreferNone will cause subsequent
  -- * kernel launches to prefer to not change the cache configuration unless
  -- * required to launch the kernel.
  -- *
  -- * This setting does nothing on devices where the size of the L1 cache and
  -- * shared memory are fixed.
  -- *
  -- * Launching a kernel with a different preference than the most recent
  -- * preference setting may insert a device-side synchronization point.
  -- *
  -- * The supported cache configurations are:
  -- * - ::cudaFuncCachePreferNone: no preference for shared memory or L1 (default)
  -- * - ::cudaFuncCachePreferShared: prefer larger shared memory and smaller L1 cache
  -- * - ::cudaFuncCachePreferL1: prefer larger L1 cache and smaller shared memory
  -- *
  -- * \param cacheConfig - Requested cache configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceSetCacheConfig
  --  

   function cudaThreadSetCacheConfig (cacheConfig : driver_types_h.cudaFuncCache) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1020
   pragma Import (C, cudaThreadSetCacheConfig, "cudaThreadSetCacheConfig");

  --* @}  
  -- END CUDART_THREAD_DEPRECATED  
  --*
  -- * \defgroup CUDART_ERROR Error Handling
  -- *
  -- * ___MANBRIEF___ error handling functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the error handling functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Returns the last error from a runtime call
  -- *
  -- * Returns the last error that has been produced by any of the runtime calls
  -- * in the same host thread and resets it to ::cudaSuccess.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMissingConfiguration,
  -- * ::cudaErrorMemoryAllocation,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorLaunchFailure,
  -- * ::cudaErrorLaunchTimeout,
  -- * ::cudaErrorLaunchOutOfResources,
  -- * ::cudaErrorInvalidDeviceFunction,
  -- * ::cudaErrorInvalidConfiguration,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidSymbol,
  -- * ::cudaErrorUnmapBufferObjectFailed,
  -- * ::cudaErrorInvalidHostPointer,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidTexture,
  -- * ::cudaErrorInvalidTextureBinding,
  -- * ::cudaErrorInvalidChannelDescriptor,
  -- * ::cudaErrorInvalidMemcpyDirection,
  -- * ::cudaErrorInvalidFilterSetting,
  -- * ::cudaErrorInvalidNormSetting,
  -- * ::cudaErrorUnknown,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorInsufficientDriver,
  -- * ::cudaErrorSetOnActiveProcess,
  -- * ::cudaErrorStartupFailure,
  -- * \notefnerr
  -- *
  -- * \sa ::cudaPeekAtLastError, ::cudaGetErrorName, ::cudaGetErrorString, ::cudaError
  --  

   function cudaGetLastError return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1074
   pragma Import (C, cudaGetLastError, "cudaGetLastError");

  --*
  -- * \brief Returns the last error from a runtime call
  -- *
  -- * Returns the last error that has been produced by any of the runtime calls
  -- * in the same host thread. Note that this call does not reset the error to
  -- * ::cudaSuccess like ::cudaGetLastError().
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMissingConfiguration,
  -- * ::cudaErrorMemoryAllocation,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorLaunchFailure,
  -- * ::cudaErrorLaunchTimeout,
  -- * ::cudaErrorLaunchOutOfResources,
  -- * ::cudaErrorInvalidDeviceFunction,
  -- * ::cudaErrorInvalidConfiguration,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidSymbol,
  -- * ::cudaErrorUnmapBufferObjectFailed,
  -- * ::cudaErrorInvalidHostPointer,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidTexture,
  -- * ::cudaErrorInvalidTextureBinding,
  -- * ::cudaErrorInvalidChannelDescriptor,
  -- * ::cudaErrorInvalidMemcpyDirection,
  -- * ::cudaErrorInvalidFilterSetting,
  -- * ::cudaErrorInvalidNormSetting,
  -- * ::cudaErrorUnknown,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorInsufficientDriver,
  -- * ::cudaErrorSetOnActiveProcess,
  -- * ::cudaErrorStartupFailure,
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGetLastError, ::cudaGetErrorName, ::cudaGetErrorString, ::cudaError
  --  

   function cudaPeekAtLastError return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1115
   pragma Import (C, cudaPeekAtLastError, "cudaPeekAtLastError");

  --*
  -- * \brief Returns the string representation of an error code enum name
  -- *
  -- * Returns a string containing the name of an error code in the enum.  If the error
  -- * code is not recognized, "unrecognized error code" is returned.
  -- *
  -- * \param error - Error code to convert to string
  -- *
  -- * \return
  -- * \p char* pointer to a NULL-terminated string
  -- *
  -- * \sa ::cudaGetErrorString, ::cudaGetLastError, ::cudaPeekAtLastError, ::cudaError
  --  

   function cudaGetErrorName (error : driver_types_h.cudaError_t) return Interfaces.C.Strings.chars_ptr;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1130
   pragma Import (C, cudaGetErrorName, "cudaGetErrorName");

  --*
  -- * \brief Returns the description string for an error code
  -- *
  -- * Returns the description string for an error code.  If the error
  -- * code is not recognized, "unrecognized error code" is returned.
  -- *
  -- * \param error - Error code to convert to string
  -- *
  -- * \return
  -- * \p char* pointer to a NULL-terminated string
  -- *
  -- * \sa ::cudaGetErrorName, ::cudaGetLastError, ::cudaPeekAtLastError, ::cudaError
  --  

   function cudaGetErrorString (error : driver_types_h.cudaError_t) return Interfaces.C.Strings.chars_ptr;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1145
   pragma Import (C, cudaGetErrorString, "cudaGetErrorString");

  --* @}  
  -- END CUDART_ERROR  
  --*
  -- * \addtogroup CUDART_DEVICE 
  -- *
  -- * @{
  --  

  --*
  -- * \brief Returns the number of compute-capable devices
  -- *
  -- * Returns in \p *count the number of devices with compute capability greater
  -- * or equal to 2.0 that are available for execution.  If there is no such
  -- * device then ::cudaGetDeviceCount() will return ::cudaErrorNoDevice.
  -- * If no driver can be loaded to determine if any such devices exist then
  -- * ::cudaGetDeviceCount() will return ::cudaErrorInsufficientDriver.
  -- *
  -- * \param count - Returns the number of devices with compute capability
  -- * greater or equal to 2.0
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorNoDevice,
  -- * ::cudaErrorInsufficientDriver
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGetDevice, ::cudaSetDevice, ::cudaGetDeviceProperties,
  -- * ::cudaChooseDevice
  --  

   function cudaGetDeviceCount (count : access int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1175
   pragma Import (C, cudaGetDeviceCount, "cudaGetDeviceCount");

  --*
  -- * \brief Returns information about the compute-device
  -- *
  -- * Returns in \p *prop the properties of device \p dev. The ::cudaDeviceProp
  -- * structure is defined as:
  -- * \code
  --    struct cudaDeviceProp {
  --        char name[256];
  --        size_t totalGlobalMem;
  --        size_t sharedMemPerBlock;
  --        int regsPerBlock;
  --        int warpSize;
  --        size_t memPitch;
  --        int maxThreadsPerBlock;
  --        int maxThreadsDim[3];
  --        int maxGridSize[3];
  --        int clockRate;
  --        size_t totalConstMem;
  --        int major;
  --        int minor;
  --        size_t textureAlignment;
  --        size_t texturePitchAlignment;
  --        int deviceOverlap;
  --        int multiProcessorCount;
  --        int kernelExecTimeoutEnabled;
  --        int integrated;
  --        int canMapHostMemory;
  --        int computeMode;
  --        int maxTexture1D;
  --        int maxTexture1DMipmap;
  --        int maxTexture1DLinear;
  --        int maxTexture2D[2];
  --        int maxTexture2DMipmap[2];
  --        int maxTexture2DLinear[3];
  --        int maxTexture2DGather[2];
  --        int maxTexture3D[3];
  --        int maxTexture3DAlt[3];
  --        int maxTextureCubemap;
  --        int maxTexture1DLayered[2];
  --        int maxTexture2DLayered[3];
  --        int maxTextureCubemapLayered[2];
  --        int maxSurface1D;
  --        int maxSurface2D[2];
  --        int maxSurface3D[3];
  --        int maxSurface1DLayered[2];
  --        int maxSurface2DLayered[3];
  --        int maxSurfaceCubemap;
  --        int maxSurfaceCubemapLayered[2];
  --        size_t surfaceAlignment;
  --        int concurrentKernels;
  --        int ECCEnabled;
  --        int pciBusID;
  --        int pciDeviceID;
  --        int pciDomainID;
  --        int tccDriver;
  --        int asyncEngineCount;
  --        int unifiedAddressing;
  --        int memoryClockRate;
  --        int memoryBusWidth;
  --        int l2CacheSize;
  --        int maxThreadsPerMultiProcessor;
  --        int streamPrioritiesSupported;
  --        int globalL1CacheSupported;
  --        int localL1CacheSupported;
  --        size_t sharedMemPerMultiprocessor;
  --        int regsPerMultiprocessor;
  --        int managedMemSupported;
  --        int isMultiGpuBoard;
  --        int multiGpuBoardGroupID;
  --        int singleToDoublePrecisionPerfRatio;
  --        int pageableMemoryAccess;
  --        int concurrentManagedAccess;
  --    }
  -- \endcode
  -- * where:
  -- * - \ref ::cudaDeviceProp::name "name[256]" is an ASCII string identifying
  -- *   the device;
  -- * - \ref ::cudaDeviceProp::totalGlobalMem "totalGlobalMem" is the total
  -- *   amount of global memory available on the device in bytes;
  -- * - \ref ::cudaDeviceProp::sharedMemPerBlock "sharedMemPerBlock" is the
  -- *   maximum amount of shared memory available to a thread block in bytes;
  -- * - \ref ::cudaDeviceProp::regsPerBlock "regsPerBlock" is the maximum number
  -- *   of 32-bit registers available to a thread block;
  -- * - \ref ::cudaDeviceProp::warpSize "warpSize" is the warp size in threads;
  -- * - \ref ::cudaDeviceProp::memPitch "memPitch" is the maximum pitch in
  -- *   bytes allowed by the memory copy functions that involve memory regions
  -- *   allocated through ::cudaMallocPitch();
  -- * - \ref ::cudaDeviceProp::maxThreadsPerBlock "maxThreadsPerBlock" is the
  -- *   maximum number of threads per block;
  -- * - \ref ::cudaDeviceProp::maxThreadsDim "maxThreadsDim[3]" contains the
  -- *   maximum size of each dimension of a block;
  -- * - \ref ::cudaDeviceProp::maxGridSize "maxGridSize[3]" contains the
  -- *   maximum size of each dimension of a grid;
  -- * - \ref ::cudaDeviceProp::clockRate "clockRate" is the clock frequency in
  -- *   kilohertz;
  -- * - \ref ::cudaDeviceProp::totalConstMem "totalConstMem" is the total amount
  -- *   of constant memory available on the device in bytes;
  -- * - \ref ::cudaDeviceProp::major "major",
  -- *   \ref ::cudaDeviceProp::minor "minor" are the major and minor revision
  -- *   numbers defining the device's compute capability;
  -- * - \ref ::cudaDeviceProp::textureAlignment "textureAlignment" is the
  -- *   alignment requirement; texture base addresses that are aligned to
  -- *   \ref ::cudaDeviceProp::textureAlignment "textureAlignment" bytes do not
  -- *   need an offset applied to texture fetches;
  -- * - \ref ::cudaDeviceProp::texturePitchAlignment "texturePitchAlignment" is the
  -- *   pitch alignment requirement for 2D texture references that are bound to 
  -- *   pitched memory;
  -- * - \ref ::cudaDeviceProp::deviceOverlap "deviceOverlap" is 1 if the device
  -- *   can concurrently copy memory between host and device while executing a
  -- *   kernel, or 0 if not.  Deprecated, use instead asyncEngineCount.
  -- * - \ref ::cudaDeviceProp::multiProcessorCount "multiProcessorCount" is the
  -- *   number of multiprocessors on the device;
  -- * - \ref ::cudaDeviceProp::kernelExecTimeoutEnabled "kernelExecTimeoutEnabled"
  -- *   is 1 if there is a run time limit for kernels executed on the device, or
  -- *   0 if not.
  -- * - \ref ::cudaDeviceProp::integrated "integrated" is 1 if the device is an
  -- *   integrated (motherboard) GPU and 0 if it is a discrete (card) component.
  -- * - \ref ::cudaDeviceProp::canMapHostMemory "canMapHostMemory" is 1 if the
  -- *   device can map host memory into the CUDA address space for use with
  -- *   ::cudaHostAlloc()/::cudaHostGetDevicePointer(), or 0 if not;
  -- * - \ref ::cudaDeviceProp::computeMode "computeMode" is the compute mode
  -- *   that the device is currently in. Available modes are as follows:
  -- *   - cudaComputeModeDefault: Default mode - Device is not restricted and
  -- *     multiple threads can use ::cudaSetDevice() with this device.
  -- *   - cudaComputeModeExclusive: Compute-exclusive mode - Only one thread will
  -- *     be able to use ::cudaSetDevice() with this device.
  -- *   - cudaComputeModeProhibited: Compute-prohibited mode - No threads can use
  -- *     ::cudaSetDevice() with this device.
  -- *   - cudaComputeModeExclusiveProcess: Compute-exclusive-process mode - Many 
  -- *     threads in one process will be able to use ::cudaSetDevice() with this device.
  -- *   <br> If ::cudaSetDevice() is called on an already occupied \p device with 
  -- *   computeMode ::cudaComputeModeExclusive, ::cudaErrorDeviceAlreadyInUse
  -- *   will be immediately returned indicating the device cannot be used.
  -- *   When an occupied exclusive mode device is chosen with ::cudaSetDevice,
  -- *   all subsequent non-device management runtime functions will return
  -- *   ::cudaErrorDevicesUnavailable.
  -- * - \ref ::cudaDeviceProp::maxTexture1D "maxTexture1D" is the maximum 1D
  -- *   texture size.
  -- * - \ref ::cudaDeviceProp::maxTexture1DMipmap "maxTexture1DMipmap" is the maximum
  -- *   1D mipmapped texture texture size.
  -- * - \ref ::cudaDeviceProp::maxTexture1DLinear "maxTexture1DLinear" is the maximum
  -- *   1D texture size for textures bound to linear memory.
  -- * - \ref ::cudaDeviceProp::maxTexture2D "maxTexture2D[2]" contains the maximum
  -- *   2D texture dimensions.
  -- * - \ref ::cudaDeviceProp::maxTexture2DMipmap "maxTexture2DMipmap[2]" contains the
  -- *   maximum 2D mipmapped texture dimensions.
  -- * - \ref ::cudaDeviceProp::maxTexture2DLinear "maxTexture2DLinear[3]" contains the 
  -- *   maximum 2D texture dimensions for 2D textures bound to pitch linear memory.
  -- * - \ref ::cudaDeviceProp::maxTexture2DGather "maxTexture2DGather[2]" contains the 
  -- *   maximum 2D texture dimensions if texture gather operations have to be performed.
  -- * - \ref ::cudaDeviceProp::maxTexture3D "maxTexture3D[3]" contains the maximum
  -- *   3D texture dimensions.
  -- * - \ref ::cudaDeviceProp::maxTexture3DAlt "maxTexture3DAlt[3]"
  -- *   contains the maximum alternate 3D texture dimensions.
  -- * - \ref ::cudaDeviceProp::maxTextureCubemap "maxTextureCubemap" is the 
  -- *   maximum cubemap texture width or height.
  -- * - \ref ::cudaDeviceProp::maxTexture1DLayered "maxTexture1DLayered[2]" contains
  -- *   the maximum 1D layered texture dimensions.
  -- * - \ref ::cudaDeviceProp::maxTexture2DLayered "maxTexture2DLayered[3]" contains
  -- *   the maximum 2D layered texture dimensions.
  -- * - \ref ::cudaDeviceProp::maxTextureCubemapLayered "maxTextureCubemapLayered[2]"
  -- *   contains the maximum cubemap layered texture dimensions.
  -- * - \ref ::cudaDeviceProp::maxSurface1D "maxSurface1D" is the maximum 1D
  -- *   surface size.
  -- * - \ref ::cudaDeviceProp::maxSurface2D "maxSurface2D[2]" contains the maximum
  -- *   2D surface dimensions.
  -- * - \ref ::cudaDeviceProp::maxSurface3D "maxSurface3D[3]" contains the maximum
  -- *   3D surface dimensions.
  -- * - \ref ::cudaDeviceProp::maxSurface1DLayered "maxSurface1DLayered[2]" contains
  -- *   the maximum 1D layered surface dimensions.
  -- * - \ref ::cudaDeviceProp::maxSurface2DLayered "maxSurface2DLayered[3]" contains
  -- *   the maximum 2D layered surface dimensions.
  -- * - \ref ::cudaDeviceProp::maxSurfaceCubemap "maxSurfaceCubemap" is the maximum 
  -- *   cubemap surface width or height.
  -- * - \ref ::cudaDeviceProp::maxSurfaceCubemapLayered "maxSurfaceCubemapLayered[2]"
  -- *   contains the maximum cubemap layered surface dimensions.
  -- * - \ref ::cudaDeviceProp::surfaceAlignment "surfaceAlignment" specifies the
  -- *   alignment requirements for surfaces.
  -- * - \ref ::cudaDeviceProp::concurrentKernels "concurrentKernels" is 1 if the
  -- *   device supports executing multiple kernels within the same context
  -- *   simultaneously, or 0 if not. It is not guaranteed that multiple kernels
  -- *   will be resident on the device concurrently so this feature should not be
  -- *   relied upon for correctness;
  -- * - \ref ::cudaDeviceProp::ECCEnabled "ECCEnabled" is 1 if the device has ECC
  -- *   support turned on, or 0 if not.
  -- * - \ref ::cudaDeviceProp::pciBusID "pciBusID" is the PCI bus identifier of
  -- *   the device.
  -- * - \ref ::cudaDeviceProp::pciDeviceID "pciDeviceID" is the PCI device
  -- *   (sometimes called slot) identifier of the device.
  -- * - \ref ::cudaDeviceProp::pciDomainID "pciDomainID" is the PCI domain identifier
  -- *   of the device.
  -- * - \ref ::cudaDeviceProp::tccDriver "tccDriver" is 1 if the device is using a
  -- *   TCC driver or 0 if not.
  -- * - \ref ::cudaDeviceProp::asyncEngineCount "asyncEngineCount" is 1 when the
  -- *   device can concurrently copy memory between host and device while executing
  -- *   a kernel. It is 2 when the device can concurrently copy memory between host
  -- *   and device in both directions and execute a kernel at the same time. It is
  -- *   0 if neither of these is supported.
  -- * - \ref ::cudaDeviceProp::unifiedAddressing "unifiedAddressing" is 1 if the device 
  -- *   shares a unified address space with the host and 0 otherwise.
  -- * - \ref ::cudaDeviceProp::memoryClockRate "memoryClockRate" is the peak memory 
  -- *   clock frequency in kilohertz.
  -- * - \ref ::cudaDeviceProp::memoryBusWidth "memoryBusWidth" is the memory bus width  
  -- *   in bits.
  -- * - \ref ::cudaDeviceProp::l2CacheSize "l2CacheSize" is L2 cache size in bytes. 
  -- * - \ref ::cudaDeviceProp::maxThreadsPerMultiProcessor "maxThreadsPerMultiProcessor"  
  -- *   is the number of maximum resident threads per multiprocessor.
  -- * - \ref ::cudaDeviceProp::streamPrioritiesSupported "streamPrioritiesSupported"
  -- *   is 1 if the device supports stream priorities, or 0 if it is not supported.
  -- * - \ref ::cudaDeviceProp::globalL1CacheSupported "globalL1CacheSupported"
  -- *   is 1 if the device supports caching of globals in L1 cache, or 0 if it is not supported.
  -- * - \ref ::cudaDeviceProp::localL1CacheSupported "localL1CacheSupported"
  -- *   is 1 if the device supports caching of locals in L1 cache, or 0 if it is not supported.
  -- * - \ref ::cudaDeviceProp::sharedMemPerMultiprocessor "sharedMemPerMultiprocessor" is the
  -- *   maximum amount of shared memory available to a multiprocessor in bytes; this amount is
  -- *   shared by all thread blocks simultaneously resident on a multiprocessor;
  -- * - \ref ::cudaDeviceProp::regsPerMultiprocessor "regsPerMultiprocessor" is the maximum number
  -- *   of 32-bit registers available to a multiprocessor; this number is shared
  -- *   by all thread blocks simultaneously resident on a multiprocessor;
  -- * - \ref ::cudaDeviceProp::managedMemory "managedMemory"
  -- *   is 1 if the device supports allocating managed memory on this system, or 0 if it is not supported.
  -- * - \ref ::cudaDeviceProp::isMultiGpuBoard "isMultiGpuBoard"
  -- *   is 1 if the device is on a multi-GPU board (e.g. Gemini cards), and 0 if not;
  -- * - \ref ::cudaDeviceProp::multiGpuBoardGroupID "multiGpuBoardGroupID" is a unique identifier
  -- *   for a group of devices associated with the same board.
  -- *   Devices on the same multi-GPU board will share the same identifier;
  -- * - \ref ::cudaDeviceProp::singleToDoublePrecisionPerfRatio "singleToDoublePrecisionPerfRatio"  
  -- *   is the ratio of single precision performance (in floating-point operations per second)
  -- *   to double precision performance.
  -- * - \ref ::cudaDeviceProp::pageableMemoryAccess "pageableMemoryAccess" is 1 if the device supports
  -- *   coherently accessing pageable memory without calling cudaHostRegister on it, and 0 otherwise.
  -- * - \ref ::cudaDeviceProp::concurrentManagedAccess "concurrentManagedAccess" is 1 if the device can
  -- *   coherently access managed memory concurrently with the CPU, and 0 otherwise.
  -- *
  -- * \param prop   - Properties for the specified device
  -- * \param device - Device number to get properties for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice
  -- *
  -- * \sa ::cudaGetDeviceCount, ::cudaGetDevice, ::cudaSetDevice, ::cudaChooseDevice,
  -- * ::cudaDeviceGetAttribute
  --  

   function cudaGetDeviceProperties (prop : access driver_types_h.cudaDeviceProp; device : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1421
   pragma Import (C, cudaGetDeviceProperties, "cudaGetDeviceProperties");

  --*
  -- * \brief Returns information about the device
  -- *
  -- * Returns in \p *value the integer value of the attribute \p attr on device
  -- * \p device. The supported attributes are:
  -- * - ::cudaDevAttrMaxThreadsPerBlock: Maximum number of threads per block;
  -- * - ::cudaDevAttrMaxBlockDimX: Maximum x-dimension of a block;
  -- * - ::cudaDevAttrMaxBlockDimY: Maximum y-dimension of a block;
  -- * - ::cudaDevAttrMaxBlockDimZ: Maximum z-dimension of a block;
  -- * - ::cudaDevAttrMaxGridDimX: Maximum x-dimension of a grid;
  -- * - ::cudaDevAttrMaxGridDimY: Maximum y-dimension of a grid;
  -- * - ::cudaDevAttrMaxGridDimZ: Maximum z-dimension of a grid;
  -- * - ::cudaDevAttrMaxSharedMemoryPerBlock: Maximum amount of shared memory
  -- *   available to a thread block in bytes;
  -- * - ::cudaDevAttrTotalConstantMemory: Memory available on device for
  -- *   __constant__ variables in a CUDA C kernel in bytes;
  -- * - ::cudaDevAttrWarpSize: Warp size in threads;
  -- * - ::cudaDevAttrMaxPitch: Maximum pitch in bytes allowed by the memory copy
  -- *   functions that involve memory regions allocated through ::cudaMallocPitch();
  -- * - ::cudaDevAttrMaxTexture1DWidth: Maximum 1D texture width;
  -- * - ::cudaDevAttrMaxTexture1DLinearWidth: Maximum width for a 1D texture bound
  -- *   to linear memory;
  -- * - ::cudaDevAttrMaxTexture1DMipmappedWidth: Maximum mipmapped 1D texture width;
  -- * - ::cudaDevAttrMaxTexture2DWidth: Maximum 2D texture width;
  -- * - ::cudaDevAttrMaxTexture2DHeight: Maximum 2D texture height;
  -- * - ::cudaDevAttrMaxTexture2DLinearWidth: Maximum width for a 2D texture
  -- *   bound to linear memory;
  -- * - ::cudaDevAttrMaxTexture2DLinearHeight: Maximum height for a 2D texture
  -- *   bound to linear memory;
  -- * - ::cudaDevAttrMaxTexture2DLinearPitch: Maximum pitch in bytes for a 2D
  -- *   texture bound to linear memory;
  -- * - ::cudaDevAttrMaxTexture2DMipmappedWidth: Maximum mipmapped 2D texture
  -- *   width;
  -- * - ::cudaDevAttrMaxTexture2DMipmappedHeight: Maximum mipmapped 2D texture
  -- *   height;
  -- * - ::cudaDevAttrMaxTexture3DWidth: Maximum 3D texture width;
  -- * - ::cudaDevAttrMaxTexture3DHeight: Maximum 3D texture height;
  -- * - ::cudaDevAttrMaxTexture3DDepth: Maximum 3D texture depth;
  -- * - ::cudaDevAttrMaxTexture3DWidthAlt: Alternate maximum 3D texture width,
  -- *   0 if no alternate maximum 3D texture size is supported;
  -- * - ::cudaDevAttrMaxTexture3DHeightAlt: Alternate maximum 3D texture height,
  -- *   0 if no alternate maximum 3D texture size is supported;
  -- * - ::cudaDevAttrMaxTexture3DDepthAlt: Alternate maximum 3D texture depth,
  -- *   0 if no alternate maximum 3D texture size is supported;
  -- * - ::cudaDevAttrMaxTextureCubemapWidth: Maximum cubemap texture width or
  -- *   height;
  -- * - ::cudaDevAttrMaxTexture1DLayeredWidth: Maximum 1D layered texture width;
  -- * - ::cudaDevAttrMaxTexture1DLayeredLayers: Maximum layers in a 1D layered
  -- *   texture;
  -- * - ::cudaDevAttrMaxTexture2DLayeredWidth: Maximum 2D layered texture width;
  -- * - ::cudaDevAttrMaxTexture2DLayeredHeight: Maximum 2D layered texture height;
  -- * - ::cudaDevAttrMaxTexture2DLayeredLayers: Maximum layers in a 2D layered
  -- *   texture;
  -- * - ::cudaDevAttrMaxTextureCubemapLayeredWidth: Maximum cubemap layered
  -- *   texture width or height;
  -- * - ::cudaDevAttrMaxTextureCubemapLayeredLayers: Maximum layers in a cubemap
  -- *   layered texture;
  -- * - ::cudaDevAttrMaxSurface1DWidth: Maximum 1D surface width;
  -- * - ::cudaDevAttrMaxSurface2DWidth: Maximum 2D surface width;
  -- * - ::cudaDevAttrMaxSurface2DHeight: Maximum 2D surface height;
  -- * - ::cudaDevAttrMaxSurface3DWidth: Maximum 3D surface width;
  -- * - ::cudaDevAttrMaxSurface3DHeight: Maximum 3D surface height;
  -- * - ::cudaDevAttrMaxSurface3DDepth: Maximum 3D surface depth;
  -- * - ::cudaDevAttrMaxSurface1DLayeredWidth: Maximum 1D layered surface width;
  -- * - ::cudaDevAttrMaxSurface1DLayeredLayers: Maximum layers in a 1D layered
  -- *   surface;
  -- * - ::cudaDevAttrMaxSurface2DLayeredWidth: Maximum 2D layered surface width;
  -- * - ::cudaDevAttrMaxSurface2DLayeredHeight: Maximum 2D layered surface height;
  -- * - ::cudaDevAttrMaxSurface2DLayeredLayers: Maximum layers in a 2D layered
  -- *   surface;
  -- * - ::cudaDevAttrMaxSurfaceCubemapWidth: Maximum cubemap surface width;
  -- * - ::cudaDevAttrMaxSurfaceCubemapLayeredWidth: Maximum cubemap layered
  -- *   surface width;
  -- * - ::cudaDevAttrMaxSurfaceCubemapLayeredLayers: Maximum layers in a cubemap
  -- *   layered surface;
  -- * - ::cudaDevAttrMaxRegistersPerBlock: Maximum number of 32-bit registers 
  -- *   available to a thread block;
  -- * - ::cudaDevAttrClockRate: Peak clock frequency in kilohertz;
  -- * - ::cudaDevAttrTextureAlignment: Alignment requirement; texture base
  -- *   addresses aligned to ::textureAlign bytes do not need an offset applied
  -- *   to texture fetches;
  -- * - ::cudaDevAttrTexturePitchAlignment: Pitch alignment requirement for 2D
  -- *   texture references bound to pitched memory;
  -- * - ::cudaDevAttrGpuOverlap: 1 if the device can concurrently copy memory
  -- *   between host and device while executing a kernel, or 0 if not;
  -- * - ::cudaDevAttrMultiProcessorCount: Number of multiprocessors on the device;
  -- * - ::cudaDevAttrKernelExecTimeout: 1 if there is a run time limit for kernels
  -- *   executed on the device, or 0 if not;
  -- * - ::cudaDevAttrIntegrated: 1 if the device is integrated with the memory
  -- *   subsystem, or 0 if not;
  -- * - ::cudaDevAttrCanMapHostMemory: 1 if the device can map host memory into
  -- *   the CUDA address space, or 0 if not;
  -- * - ::cudaDevAttrComputeMode: Compute mode is the compute mode that the device
  -- *   is currently in. Available modes are as follows:
  -- *   - ::cudaComputeModeDefault: Default mode - Device is not restricted and
  -- *     multiple threads can use ::cudaSetDevice() with this device.
  -- *   - ::cudaComputeModeExclusive: Compute-exclusive mode - Only one thread will
  -- *     be able to use ::cudaSetDevice() with this device.
  -- *   - ::cudaComputeModeProhibited: Compute-prohibited mode - No threads can use
  -- *     ::cudaSetDevice() with this device.
  -- *   - ::cudaComputeModeExclusiveProcess: Compute-exclusive-process mode - Many 
  -- *     threads in one process will be able to use ::cudaSetDevice() with this
  -- *     device.
  -- * - ::cudaDevAttrConcurrentKernels: 1 if the device supports executing
  -- *   multiple kernels within the same context simultaneously, or 0 if
  -- *   not. It is not guaranteed that multiple kernels will be resident on the
  -- *   device concurrently so this feature should not be relied upon for
  -- *   correctness;
  -- * - ::cudaDevAttrEccEnabled: 1 if error correction is enabled on the device,
  -- *   0 if error correction is disabled or not supported by the device;
  -- * - ::cudaDevAttrPciBusId: PCI bus identifier of the device;
  -- * - ::cudaDevAttrPciDeviceId: PCI device (also known as slot) identifier of
  -- *   the device;
  -- * - ::cudaDevAttrTccDriver: 1 if the device is using a TCC driver. TCC is only
  -- *   available on Tesla hardware running Windows Vista or later;
  -- * - ::cudaDevAttrMemoryClockRate: Peak memory clock frequency in kilohertz;
  -- * - ::cudaDevAttrGlobalMemoryBusWidth: Global memory bus width in bits;
  -- * - ::cudaDevAttrL2CacheSize: Size of L2 cache in bytes. 0 if the device
  -- *   doesn't have L2 cache;
  -- * - ::cudaDevAttrMaxThreadsPerMultiProcessor: Maximum resident threads per 
  -- *   multiprocessor;
  -- * - ::cudaDevAttrUnifiedAddressing: 1 if the device shares a unified address
  -- *   space with the host, or 0 if not;
  -- * - ::cudaDevAttrComputeCapabilityMajor: Major compute capability version
  -- *   number;
  -- * - ::cudaDevAttrComputeCapabilityMinor: Minor compute capability version
  -- *   number;
  -- * - ::cudaDevAttrStreamPrioritiesSupported: 1 if the device supports stream
  -- *   priorities, or 0 if not;
  -- * - ::cudaDevAttrGlobalL1CacheSupported: 1 if device supports caching globals 
  -- *    in L1 cache, 0 if not;
  -- * - ::cudaDevAttrGlobalL1CacheSupported: 1 if device supports caching locals 
  -- *    in L1 cache, 0 if not;
  -- * - ::cudaDevAttrMaxSharedMemoryPerMultiprocessor: Maximum amount of shared memory
  -- *   available to a multiprocessor in bytes; this amount is shared by all 
  -- *   thread blocks simultaneously resident on a multiprocessor;
  -- * - ::cudaDevAttrMaxRegistersPerMultiprocessor: Maximum number of 32-bit registers 
  -- *   available to a multiprocessor; this number is shared by all thread blocks
  -- *   simultaneously resident on a multiprocessor;
  -- * - ::cudaDevAttrManagedMemSupported: 1 if device supports allocating
  -- *   managed memory, 0 if not;
  -- * - ::cudaDevAttrIsMultiGpuBoard: 1 if device is on a multi-GPU board, 0 if not;
  -- * - ::cudaDevAttrMultiGpuBoardGroupID: Unique identifier for a group of devices on the
  -- *   same multi-GPU board;
  -- * - ::cudaDevAttrHostNativeAtomicSupported: 1 if the link between the device and the
  -- *   host supports native atomic operations;
  -- * - ::cudaDevAttrSingleToDoublePrecisionPerfRatio: Ratio of single precision performance
  -- *   (in floating-point operations per second) to double precision performance;
  -- * - ::cudaDevAttrPageableMemoryAccess: 1 if the device supports coherently accessing
  -- *   pageable memory without calling cudaHostRegister on it, and 0 otherwise.
  -- * - ::cudaDevAttrConcurrentManagedAccess: 1 if the device can coherently access managed
  -- *   memory concurrently with the CPU, and 0 otherwise.
  -- * - ::cudaDevAttrComputePreemptionSupported: 1 if the device supports
  -- *   Compute Preemption, 0 if not.
  -- * - ::cudaDevAttrCanUseHostPointerForRegisteredMem: 1 if the device can access host
  -- *   registered memory at the same virtual address as the CPU, and 0 otherwise.
  -- *
  -- * \param value  - Returned device attribute value
  -- * \param attr   - Device attribute to query
  -- * \param device - Device number to query 
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGetDeviceCount, ::cudaGetDevice, ::cudaSetDevice, ::cudaChooseDevice,
  -- * ::cudaGetDeviceProperties
  --  

   function cudaDeviceGetAttribute
     (value : access int;
      attr : driver_types_h.cudaDeviceAttr;
      device : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1593
   pragma Import (C, cudaDeviceGetAttribute, "cudaDeviceGetAttribute");

  --*
  -- * \brief Queries attributes of the link between two devices.
  -- *
  -- * Returns in \p *value the value of the requested attribute \p attrib of the
  -- * link between \p srcDevice and \p dstDevice. The supported attributes are:
  -- * - ::CudaDevP2PAttrPerformanceRank: A relative value indicating the
  -- *   performance of the link between two devices. Lower value means better
  -- *   performance (0 being the value used for most performant link).
  -- * - ::CudaDevP2PAttrAccessSupported: 1 if peer access is enabled.
  -- * - ::CudaDevP2PAttrNativeAtomicSupported: 1 if native atomic operations over
  -- *   the link are supported.
  -- *
  -- * Returns ::cudaErrorInvalidDevice if \p srcDevice or \p dstDevice are not valid
  -- * or if they represent the same device.
  -- *
  -- * Returns ::cudaErrorInvalidValue if \p attrib is not valid or if \p value is
  -- * a null pointer.
  -- *
  -- * \param value         - Returned value of the requested attribute
  -- * \param attrib        - The requested attribute of the link between \p srcDevice and \p dstDevice.
  -- * \param srcDevice     - The source device of the target link.
  -- * \param dstDevice     - The destination device of the target link.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaCtxEnablePeerAccess,
  -- * ::cudaCtxDisablePeerAccess,
  -- * ::cudaCtxCanAccessPeer
  --  

   function cudaDeviceGetP2PAttribute
     (value : access int;
      attr : driver_types_h.cudaDeviceP2PAttr;
      srcDevice : int;
      dstDevice : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1628
   pragma Import (C, cudaDeviceGetP2PAttribute, "cudaDeviceGetP2PAttribute");

  --*
  -- * \brief Select compute-device which best matches criteria
  -- *
  -- * Returns in \p *device the device which has properties that best match
  -- * \p *prop.
  -- *
  -- * \param device - Device with best match
  -- * \param prop   - Desired device properties
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGetDeviceCount, ::cudaGetDevice, ::cudaSetDevice,
  -- * ::cudaGetDeviceProperties
  --  

   function cudaChooseDevice (device : access int; prop : access constant driver_types_h.cudaDeviceProp) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1647
   pragma Import (C, cudaChooseDevice, "cudaChooseDevice");

  --*
  -- * \brief Set device to be used for GPU executions
  -- *
  -- * Sets \p device as the current device for the calling host thread.
  -- * Valid device id's are 0 to (::cudaGetDeviceCount() - 1).
  -- *
  -- * Any device memory subsequently allocated from this host thread
  -- * using ::cudaMalloc(), ::cudaMallocPitch() or ::cudaMallocArray()
  -- * will be physically resident on \p device.  Any host memory allocated
  -- * from this host thread using ::cudaMallocHost() or ::cudaHostAlloc() 
  -- * or ::cudaHostRegister() will have its lifetime associated  with
  -- * \p device.  Any streams or events created from this host thread will 
  -- * be associated with \p device.  Any kernels launched from this host
  -- * thread using the <<<>>> operator or ::cudaLaunchKernel() will be executed
  -- * on \p device.
  -- *
  -- * This call may be made from any host thread, to any device, and at 
  -- * any time.  This function will do no synchronization with the previous 
  -- * or new device, and should be considered a very low overhead call.
  -- *
  -- * \param device - Device on which the active host thread should execute the
  -- * device code.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorDeviceAlreadyInUse
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGetDeviceCount, ::cudaGetDevice, ::cudaGetDeviceProperties,
  -- * ::cudaChooseDevice
  --  

   function cudaSetDevice (device : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1681
   pragma Import (C, cudaSetDevice, "cudaSetDevice");

  --*
  -- * \brief Returns which device is currently being used
  -- *
  -- * Returns in \p *device the current device for the calling host thread.
  -- *
  -- * \param device - Returns the device on which the active host thread
  -- * executes the device code.
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGetDeviceCount, ::cudaSetDevice, ::cudaGetDeviceProperties,
  -- * ::cudaChooseDevice
  --  

   function cudaGetDevice (device : access int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1698
   pragma Import (C, cudaGetDevice, "cudaGetDevice");

  --*
  -- * \brief Set a list of devices that can be used for CUDA
  -- *
  -- * Sets a list of devices for CUDA execution in priority order using
  -- * \p device_arr. The parameter \p len specifies the number of elements in the
  -- * list.  CUDA will try devices from the list sequentially until it finds one
  -- * that works.  If this function is not called, or if it is called with a \p len
  -- * of 0, then CUDA will go back to its default behavior of trying devices
  -- * sequentially from a default list containing all of the available CUDA
  -- * devices in the system. If a specified device ID in the list does not exist,
  -- * this function will return ::cudaErrorInvalidDevice. If \p len is not 0 and
  -- * \p device_arr is NULL or if \p len exceeds the number of devices in
  -- * the system, then ::cudaErrorInvalidValue is returned.
  -- *
  -- * \param device_arr - List of devices to try
  -- * \param len        - Number of devices in specified list
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGetDeviceCount, ::cudaSetDevice, ::cudaGetDeviceProperties,
  -- * ::cudaSetDeviceFlags,
  -- * ::cudaChooseDevice
  --  

   function cudaSetValidDevices (device_arr : access int; len : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1727
   pragma Import (C, cudaSetValidDevices, "cudaSetValidDevices");

  --*
  -- * \brief Sets flags to be used for device executions
  -- *
  -- * Records \p flags as the flags to use when initializing the current 
  -- * device.  If no device has been made current to the calling thread,
  -- * then \p flags will be applied to the initialization of any device
  -- * initialized by the calling host thread, unless that device has had
  -- * its initialization flags set explicitly by this or any host thread.
  -- * 
  -- * If the current device has been set and that device has already been 
  -- * initialized then this call will fail with the error 
  -- * ::cudaErrorSetOnActiveProcess.  In this case it is necessary 
  -- * to reset \p device using ::cudaDeviceReset() before the device's
  -- * initialization flags may be set.
  -- *
  -- * The two LSBs of the \p flags parameter can be used to control how the CPU
  -- * thread interacts with the OS scheduler when waiting for results from the
  -- * device.
  -- *
  -- * - ::cudaDeviceScheduleAuto: The default value if the \p flags parameter is
  -- * zero, uses a heuristic based on the number of active CUDA contexts in the
  -- * process \p C and the number of logical processors in the system \p P. If
  -- * \p C \> \p P, then CUDA will yield to other OS threads when waiting for the
  -- * device, otherwise CUDA will not yield while waiting for results and
  -- * actively spin on the processor.
  -- * - ::cudaDeviceScheduleSpin: Instruct CUDA to actively spin when waiting for
  -- * results from the device. This can decrease latency when waiting for the
  -- * device, but may lower the performance of CPU threads if they are performing
  -- * work in parallel with the CUDA thread.
  -- * - ::cudaDeviceScheduleYield: Instruct CUDA to yield its thread when waiting
  -- * for results from the device. This can increase latency when waiting for the
  -- * device, but can increase the performance of CPU threads performing work in
  -- * parallel with the device.
  -- * - ::cudaDeviceScheduleBlockingSync: Instruct CUDA to block the CPU thread 
  -- * on a synchronization primitive when waiting for the device to finish work.
  -- * - ::cudaDeviceBlockingSync: Instruct CUDA to block the CPU thread on a 
  -- * synchronization primitive when waiting for the device to finish work. <br>
  -- * \ref deprecated "Deprecated:" This flag was deprecated as of CUDA 4.0 and
  -- * replaced with ::cudaDeviceScheduleBlockingSync.
  -- * - ::cudaDeviceMapHost: This flag enables allocating pinned
  -- * host memory that is accessible to the device. It is implicit for the
  -- * runtime but may be absent if a context is created using the driver API.
  -- * If this flag is not set, ::cudaHostGetDevicePointer() will always return
  -- * a failure code.
  -- * - ::cudaDeviceLmemResizeToMax: Instruct CUDA to not reduce local memory
  -- * after resizing local memory for a kernel. This can prevent thrashing by
  -- * local memory allocations when launching many kernels with high local
  -- * memory usage at the cost of potentially increased memory usage.
  -- *
  -- * \param flags - Parameters for device operation
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorSetOnActiveProcess
  -- *
  -- * \sa ::cudaGetDeviceFlags, ::cudaGetDeviceCount, ::cudaGetDevice, ::cudaGetDeviceProperties,
  -- * ::cudaSetDevice, ::cudaSetValidDevices,
  -- * ::cudaChooseDevice
  --  

   function cudaSetDeviceFlags (flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1789
   pragma Import (C, cudaSetDeviceFlags, "cudaSetDeviceFlags");

  --*
  -- * \brief Gets the flags for the current device
  -- *
  -- * Returns in \p flags the flags for the current device.  If there is a
  -- * current device for the calling thread, and the device has been initialized
  -- * or flags have been set on that device specifically, the flags for the
  -- * device are returned.  If there is no current device, but flags have been
  -- * set for the thread with ::cudaSetDeviceFlags, the thread flags are returned.
  -- * Finally, if there is no current device and no thread flags, the flags for
  -- * the first device are returned, which may be the default flags.  Compare
  -- * to the behavior of ::cudaSetDeviceFlags.
  -- *
  -- * Typically, the flags returned should match the behavior that will be seen
  -- * if the calling thread uses a device after this call, without any change to
  -- * the flags or current device inbetween by this or another thread.  Note that
  -- * if the device is not initialized, it is possible for another thread to
  -- * change the flags for the current device before it is initialized.
  -- * Additionally, when using exclusive mode, if this thread has not requested a
  -- * specific device, it may use a device other than the first device, contrary
  -- * to the assumption made by this function.
  -- *
  -- * If a context has been created via the driver API and is current to the
  -- * calling thread, the flags for that context are always returned.
  -- *
  -- * Flags returned by this function may specifically include ::cudaDeviceMapHost
  -- * even though it is not accepted by ::cudaSetDeviceFlags because it is
  -- * implicit in runtime API flags.  The reason for this is that the current
  -- * context may have been created via the driver API in which case the flag is
  -- * not implicit and may be unset.
  -- *
  -- * \param flags - Pointer to store the device flags
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice
  -- *
  -- * \sa ::cudaGetDevice, ::cudaGetDeviceProperties,
  -- * ::cudaSetDevice, ::cudaSetDeviceFlags
  --  

   function cudaGetDeviceFlags (flags : access unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1830
   pragma Import (C, cudaGetDeviceFlags, "cudaGetDeviceFlags");

  --* @}  
  -- END CUDART_DEVICE  
  --*
  -- * \defgroup CUDART_STREAM Stream Management
  -- *
  -- * ___MANBRIEF___ stream management functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the stream management functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Create an asynchronous stream
  -- *
  -- * Creates a new asynchronous stream.
  -- *
  -- * \param pStream - Pointer to new stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreateWithPriority,
  -- * ::cudaStreamCreateWithFlags,
  -- * ::cudaStreamGetPriority,
  -- * ::cudaStreamGetFlags,
  -- * ::cudaStreamQuery,
  -- * ::cudaStreamSynchronize,
  -- * ::cudaStreamWaitEvent,
  -- * ::cudaStreamAddCallback,
  -- * ::cudaStreamDestroy
  --  

   function cudaStreamCreate (pStream : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1867
   pragma Import (C, cudaStreamCreate, "cudaStreamCreate");

  --*
  -- * \brief Create an asynchronous stream
  -- *
  -- * Creates a new asynchronous stream.  The \p flags argument determines the 
  -- * behaviors of the stream.  Valid values for \p flags are
  -- * - ::cudaStreamDefault: Default stream creation flag.
  -- * - ::cudaStreamNonBlocking: Specifies that work running in the created 
  -- *   stream may run concurrently with work in stream 0 (the NULL stream), and that
  -- *   the created stream should perform no implicit synchronization with stream 0.
  -- *
  -- * \param pStream - Pointer to new stream identifier
  -- * \param flags   - Parameters for stream creation
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreate,
  -- * ::cudaStreamCreateWithPriority,
  -- * ::cudaStreamGetFlags,
  -- * ::cudaStreamQuery,
  -- * ::cudaStreamSynchronize,
  -- * ::cudaStreamWaitEvent,
  -- * ::cudaStreamAddCallback,
  -- * ::cudaStreamDestroy
  --  

   function cudaStreamCreateWithFlags (pStream : System.Address; flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1896
   pragma Import (C, cudaStreamCreateWithFlags, "cudaStreamCreateWithFlags");

  --*
  -- * \brief Create an asynchronous stream with the specified priority
  -- *
  -- * Creates a stream with the specified priority and returns a handle in \p pStream.
  -- * This API alters the scheduler priority of work in the stream. Work in a higher
  -- * priority stream may preempt work already executing in a low priority stream.
  -- *
  -- * \p priority follows a convention where lower numbers represent higher priorities.
  -- * '0' represents default priority. The range of meaningful numerical priorities can
  -- * be queried using ::cudaDeviceGetStreamPriorityRange. If the specified priority is
  -- * outside the numerical range returned by ::cudaDeviceGetStreamPriorityRange,
  -- * it will automatically be clamped to the lowest or the highest number in the range.
  -- *
  -- * \param pStream  - Pointer to new stream identifier
  -- * \param flags    - Flags for stream creation. See ::cudaStreamCreateWithFlags for a list of valid flags that can be passed
  -- * \param priority - Priority of the stream. Lower numbers represent higher priorities.
  -- *                   See ::cudaDeviceGetStreamPriorityRange for more information about
  -- *                   the meaningful stream priorities that can be passed.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \note Stream priorities are supported only on GPUs
  -- * with compute capability 3.5 or higher.
  -- *
  -- * \note In the current implementation, only compute kernels launched in
  -- * priority streams are affected by the stream's priority. Stream priorities have
  -- * no effect on host-to-device and device-to-host memory operations.
  -- *
  -- * \sa ::cudaStreamCreate,
  -- * ::cudaStreamCreateWithFlags,
  -- * ::cudaDeviceGetStreamPriorityRange,
  -- * ::cudaStreamGetPriority,
  -- * ::cudaStreamQuery,
  -- * ::cudaStreamWaitEvent,
  -- * ::cudaStreamAddCallback,
  -- * ::cudaStreamSynchronize,
  -- * ::cudaStreamDestroy
  --  

   function cudaStreamCreateWithPriority
     (pStream : System.Address;
      flags : unsigned;
      priority : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1939
   pragma Import (C, cudaStreamCreateWithPriority, "cudaStreamCreateWithPriority");

  --*
  -- * \brief Query the priority of a stream
  -- *
  -- * Query the priority of a stream. The priority is returned in in \p priority.
  -- * Note that if the stream was created with a priority outside the meaningful
  -- * numerical range returned by ::cudaDeviceGetStreamPriorityRange,
  -- * this function returns the clamped priority.
  -- * See ::cudaStreamCreateWithPriority for details about priority clamping.
  -- *
  -- * \param hStream    - Handle to the stream to be queried
  -- * \param priority   - Pointer to a signed integer in which the stream's priority is returned
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreateWithPriority,
  -- * ::cudaDeviceGetStreamPriorityRange,
  -- * ::cudaStreamGetFlags
  --  

   function cudaStreamGetPriority (hStream : driver_types_h.cudaStream_t; priority : access int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1963
   pragma Import (C, cudaStreamGetPriority, "cudaStreamGetPriority");

  --*
  -- * \brief Query the flags of a stream
  -- *
  -- * Query the flags of a stream. The flags are returned in \p flags.
  -- * See ::cudaStreamCreateWithFlags for a list of valid flags.
  -- *
  -- * \param hStream - Handle to the stream to be queried
  -- * \param flags   - Pointer to an unsigned integer in which the stream's flags are returned
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreateWithPriority,
  -- * ::cudaStreamCreateWithFlags,
  -- * ::cudaStreamGetPriority
  --  

   function cudaStreamGetFlags (hStream : driver_types_h.cudaStream_t; flags : access unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:1984
   pragma Import (C, cudaStreamGetFlags, "cudaStreamGetFlags");

  --*
  -- * \brief Destroys and cleans up an asynchronous stream
  -- *
  -- * Destroys and cleans up the asynchronous stream specified by \p stream.
  -- *
  -- * In case the device is still doing work in the stream \p stream
  -- * when ::cudaStreamDestroy() is called, the function will return immediately 
  -- * and the resources associated with \p stream will be released automatically 
  -- * once the device has completed all work in \p stream.
  -- *
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreate, ::cudaStreamCreateWithFlags, ::cudaStreamQuery, ::cudaStreamWaitEvent, ::cudaStreamSynchronize, ::cudaStreamAddCallback
  --  

   function cudaStreamDestroy (stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2005
   pragma Import (C, cudaStreamDestroy, "cudaStreamDestroy");

  --*
  -- * \brief Make a compute stream wait on an event
  -- *
  -- * Makes all future work submitted to \p stream wait until \p event reports
  -- * completion before beginning execution.  This synchronization will be
  -- * performed efficiently on the device.  The event \p event may
  -- * be from a different context than \p stream, in which case this function
  -- * will perform cross-device synchronization.
  -- *
  -- * The stream \p stream will wait only for the completion of the most recent
  -- * host call to ::cudaEventRecord() on \p event.  Once this call has returned,
  -- * any functions (including ::cudaEventRecord() and ::cudaEventDestroy()) may be
  -- * called on \p event again, and the subsequent calls will not have any effect
  -- * on \p stream.
  -- *
  -- * If ::cudaEventRecord() has not been called on \p event, this call acts as if
  -- * the record has already completed, and so is a functional no-op.
  -- *
  -- * \param stream - Stream to wait
  -- * \param event  - Event to wait on
  -- * \param flags  - Parameters for the operation (must be 0)
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle
  -- * \note_null_stream
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreate, ::cudaStreamCreateWithFlags, ::cudaStreamQuery, ::cudaStreamSynchronize, ::cudaStreamAddCallback, ::cudaStreamDestroy
  --  

   function cudaStreamWaitEvent
     (stream : driver_types_h.cudaStream_t;
      event : driver_types_h.cudaEvent_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2037
   pragma Import (C, cudaStreamWaitEvent, "cudaStreamWaitEvent");

  --*
  -- * Type of stream callback functions.
  -- * \param stream The stream as passed to ::cudaStreamAddCallback, may be NULL.
  -- * \param status ::cudaSuccess or any persistent error on the stream.
  -- * \param userData User parameter provided at registration.
  --  

   type cudaStreamCallback_t is access procedure
        (arg1 : driver_types_h.cudaStream_t;
         arg2 : driver_types_h.cudaError_t;
         arg3 : System.Address);
   pragma Convention (C, cudaStreamCallback_t);  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2051

  --*
  -- * \brief Add a callback to a compute stream
  -- *
  -- * Adds a callback to be called on the host after all currently enqueued
  -- * items in the stream have completed.  For each 
  -- * cudaStreamAddCallback call, a callback will be executed exactly once.
  -- * The callback will block later work in the stream until it is finished.
  -- *
  -- * The callback may be passed ::cudaSuccess or an error code.  In the event
  -- * of a device error, all subsequently executed callbacks will receive an
  -- * appropriate ::cudaError_t.
  -- *
  -- * Callbacks must not make any CUDA API calls.  Attempting to use CUDA APIs
  -- * will result in ::cudaErrorNotPermitted.  Callbacks must not perform any
  -- * synchronization that may depend on outstanding device work or other callbacks
  -- * that are not mandated to run earlier.  Callbacks without a mandated order
  -- * (in independent streams) execute in undefined order and may be serialized.
  -- *
  -- * For the purposes of Unified Memory, callback execution makes a number of
  -- * guarantees:
  -- * <ul>
  -- *   <li>The callback stream is considered idle for the duration of the
  -- *   callback.  Thus, for example, a callback may always use memory attached
  -- *   to the callback stream.</li>
  -- *   <li>The start of execution of a callback has the same effect as
  -- *   synchronizing an event recorded in the same stream immediately prior to
  -- *   the callback.  It thus synchronizes streams which have been "joined"
  -- *   prior to the callback.</li>
  -- *   <li>Adding device work to any stream does not have the effect of making
  -- *   the stream active until all preceding callbacks have executed.  Thus, for
  -- *   example, a callback might use global attached memory even if work has
  -- *   been added to another stream, if it has been properly ordered with an
  -- *   event.</li>
  -- *   <li>Completion of a callback does not cause a stream to become
  -- *   active except as described above.  The callback stream will remain idle
  -- *   if no device work follows the callback, and will remain idle across
  -- *   consecutive callbacks without device work in between.  Thus, for example,
  -- *   stream synchronization can be done by signaling from a callback at the
  -- *   end of the stream.</li>
  -- * </ul>
  -- *
  -- * \param stream   - Stream to add callback to
  -- * \param callback - The function to call once preceding stream operations are complete
  -- * \param userData - User specified data to be passed to the callback function
  -- * \param flags    - Reserved for future use, must be 0
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorNotSupported
  -- * \note_null_stream
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreate, ::cudaStreamCreateWithFlags, ::cudaStreamQuery, ::cudaStreamSynchronize, ::cudaStreamWaitEvent, ::cudaStreamDestroy, ::cudaMallocManaged, ::cudaStreamAttachMemAsync
  --  

   function cudaStreamAddCallback
     (stream : driver_types_h.cudaStream_t;
      callback : cudaStreamCallback_t;
      userData : System.Address;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2108
   pragma Import (C, cudaStreamAddCallback, "cudaStreamAddCallback");

  --*
  -- * \brief Waits for stream tasks to complete
  -- *
  -- * Blocks until \p stream has completed all operations. If the
  -- * ::cudaDeviceScheduleBlockingSync flag was set for this device, 
  -- * the host thread will block until the stream is finished with 
  -- * all of its tasks.
  -- *
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreate, ::cudaStreamCreateWithFlags, ::cudaStreamQuery, ::cudaStreamWaitEvent, ::cudaStreamAddCallback, ::cudaStreamDestroy
  --  

   function cudaStreamSynchronize (stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2128
   pragma Import (C, cudaStreamSynchronize, "cudaStreamSynchronize");

  --*
  -- * \brief Queries an asynchronous stream for completion status
  -- *
  -- * Returns ::cudaSuccess if all operations in \p stream have
  -- * completed, or ::cudaErrorNotReady if not.
  -- *
  -- * For the purposes of Unified Memory, a return value of ::cudaSuccess
  -- * is equivalent to having called ::cudaStreamSynchronize().
  -- *
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorNotReady,
  -- * ::cudaErrorInvalidResourceHandle
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreate, ::cudaStreamCreateWithFlags, ::cudaStreamWaitEvent, ::cudaStreamSynchronize, ::cudaStreamAddCallback, ::cudaStreamDestroy
  --  

   function cudaStreamQuery (stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2149
   pragma Import (C, cudaStreamQuery, "cudaStreamQuery");

  --*
  -- * \brief Attach memory to a stream asynchronously
  -- *
  -- * Enqueues an operation in \p stream to specify stream association of
  -- * \p length bytes of memory starting from \p devPtr. This function is a
  -- * stream-ordered operation, meaning that it is dependent on, and will
  -- * only take effect when, previous work in stream has completed. Any
  -- * previous association is automatically replaced.
  -- *
  -- * \p devPtr must point to an address within managed memory space declared
  -- * using the __managed__ keyword or allocated with ::cudaMallocManaged.
  -- *
  -- * \p length must be zero, to indicate that the entire allocation's
  -- * stream association is being changed.  Currently, it's not possible
  -- * to change stream association for a portion of an allocation. The default
  -- * value for \p length is zero.
  -- *
  -- * The stream association is specified using \p flags which must be
  -- * one of ::cudaMemAttachGlobal, ::cudaMemAttachHost or ::cudaMemAttachSingle.
  -- * The default value for \p flags is ::cudaMemAttachSingle
  -- * If the ::cudaMemAttachGlobal flag is specified, the memory can be accessed
  -- * by any stream on any device.
  -- * If the ::cudaMemAttachHost flag is specified, the program makes a guarantee
  -- * that it won't access the memory on the device from any stream on a device that
  -- * has a zero value for the device attribute ::cudaDevAttrConcurrentManagedAccess.
  -- * If the ::cudaMemAttachSingle flag is specified and \p stream is associated with
  -- * a device that has a zero value for the device attribute ::cudaDevAttrConcurrentManagedAccess,
  -- * the program makes a guarantee that it will only access the memory on the device
  -- * from \p stream. It is illegal to attach singly to the NULL stream, because the
  -- * NULL stream is a virtual global stream and not a specific stream. An error will
  -- * be returned in this case.
  -- *
  -- * When memory is associated with a single stream, the Unified Memory system will
  -- * allow CPU access to this memory region so long as all operations in \p stream
  -- * have completed, regardless of whether other streams are active. In effect,
  -- * this constrains exclusive ownership of the managed memory region by
  -- * an active GPU to per-stream activity instead of whole-GPU activity.
  -- *
  -- * Accessing memory on the device from streams that are not associated with
  -- * it will produce undefined results. No error checking is performed by the
  -- * Unified Memory system to ensure that kernels launched into other streams
  -- * do not access this region. 
  -- *
  -- * It is a program's responsibility to order calls to ::cudaStreamAttachMemAsync
  -- * via events, synchronization or other means to ensure legal access to memory
  -- * at all times. Data visibility and coherency will be changed appropriately
  -- * for all kernels which follow a stream-association change.
  -- *
  -- * If \p stream is destroyed while data is associated with it, the association is
  -- * removed and the association reverts to the default visibility of the allocation
  -- * as specified at ::cudaMallocManaged. For __managed__ variables, the default
  -- * association is always ::cudaMemAttachGlobal. Note that destroying a stream is an
  -- * asynchronous operation, and as a result, the change to default association won't
  -- * happen until all work in the stream has completed.
  -- *
  -- * \param stream  - Stream in which to enqueue the attach operation
  -- * \param devPtr  - Pointer to memory (must be a pointer to managed memory)
  -- * \param length  - Length of memory (must be zero, defaults to zero)
  -- * \param flags   - Must be one of ::cudaMemAttachGlobal, ::cudaMemAttachHost or ::cudaMemAttachSingle (defaults to ::cudaMemAttachSingle)
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorNotReady,
  -- * ::cudaErrorInvalidValue
  -- * ::cudaErrorInvalidResourceHandle
  -- * \notefnerr
  -- *
  -- * \sa ::cudaStreamCreate, ::cudaStreamCreateWithFlags, ::cudaStreamWaitEvent, ::cudaStreamSynchronize, ::cudaStreamAddCallback, ::cudaStreamDestroy, ::cudaMallocManaged
  --  

   function cudaStreamAttachMemAsync
     (stream : driver_types_h.cudaStream_t;
      devPtr : System.Address;
      length : stddef_h.size_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2220
   pragma Import (C, cudaStreamAttachMemAsync, "cudaStreamAttachMemAsync");

  --* @}  
  -- END CUDART_STREAM  
  --*
  -- * \defgroup CUDART_EVENT Event Management
  -- *
  -- * ___MANBRIEF___ event management functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the event management functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Creates an event object
  -- *
  -- * Creates an event object using ::cudaEventDefault.
  -- *
  -- * \param event - Newly created event
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorLaunchFailure,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaEventCreate(cudaEvent_t*, unsigned int) "cudaEventCreate (C++ API)",
  -- * ::cudaEventCreateWithFlags, ::cudaEventRecord, ::cudaEventQuery,
  -- * ::cudaEventSynchronize, ::cudaEventDestroy, ::cudaEventElapsedTime,
  -- * ::cudaStreamWaitEvent
  --  

   function cudaEventCreate (event : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2256
   pragma Import (C, cudaEventCreate, "cudaEventCreate");

  --*
  -- * \brief Creates an event object with the specified flags
  -- *
  -- * Creates an event object with the specified flags. Valid flags include:
  -- * - ::cudaEventDefault: Default event creation flag.
  -- * - ::cudaEventBlockingSync: Specifies that event should use blocking
  -- *   synchronization. A host thread that uses ::cudaEventSynchronize() to wait
  -- *   on an event created with this flag will block until the event actually
  -- *   completes.
  -- * - ::cudaEventDisableTiming: Specifies that the created event does not need
  -- *   to record timing data.  Events created with this flag specified and
  -- *   the ::cudaEventBlockingSync flag not specified will provide the best
  -- *   performance when used with ::cudaStreamWaitEvent() and ::cudaEventQuery().
  -- * - ::cudaEventInterprocess: Specifies that the created event may be used as an
  -- *   interprocess event by ::cudaIpcGetEventHandle(). ::cudaEventInterprocess must
  -- *   be specified along with ::cudaEventDisableTiming.
  -- *
  -- * \param event - Newly created event
  -- * \param flags - Flags for new event
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorLaunchFailure,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaEventCreate(cudaEvent_t*) "cudaEventCreate (C API)",
  -- * ::cudaEventSynchronize, ::cudaEventDestroy, ::cudaEventElapsedTime,
  -- * ::cudaStreamWaitEvent
  --  

   function cudaEventCreateWithFlags (event : System.Address; flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2290
   pragma Import (C, cudaEventCreateWithFlags, "cudaEventCreateWithFlags");

  --*
  -- * \brief Records an event
  -- *
  -- * Records an event. See note about NULL stream behavior. Since operation
  -- * is asynchronous, ::cudaEventQuery() or ::cudaEventSynchronize() must
  -- * be used to determine when the event has actually been recorded.
  -- *
  -- * If ::cudaEventRecord() has previously been called on \p event, then this
  -- * call will overwrite any existing state in \p event.  Any subsequent calls
  -- * which examine the status of \p event will only examine the completion of
  -- * this most recent call to ::cudaEventRecord().
  -- *
  -- * \param event  - Event to record
  -- * \param stream - Stream in which to record event
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorLaunchFailure
  -- * \note_null_stream
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaEventCreate(cudaEvent_t*) "cudaEventCreate (C API)",
  -- * ::cudaEventCreateWithFlags, ::cudaEventQuery,
  -- * ::cudaEventSynchronize, ::cudaEventDestroy, ::cudaEventElapsedTime,
  -- * ::cudaStreamWaitEvent
  --  

   function cudaEventRecord (event : driver_types_h.cudaEvent_t; stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2321
   pragma Import (C, cudaEventRecord, "cudaEventRecord");

  --*
  -- * \brief Queries an event's status
  -- *
  -- * Query the status of all device work preceding the most recent call to
  -- * ::cudaEventRecord() (in the appropriate compute streams, as specified by the
  -- * arguments to ::cudaEventRecord()).
  -- *
  -- * If this work has successfully been completed by the device, or if
  -- * ::cudaEventRecord() has not been called on \p event, then ::cudaSuccess is
  -- * returned. If this work has not yet been completed by the device then
  -- * ::cudaErrorNotReady is returned.
  -- *
  -- * For the purposes of Unified Memory, a return value of ::cudaSuccess
  -- * is equivalent to having called ::cudaEventSynchronize().
  -- *
  -- * \param event - Event to query
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorNotReady,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorLaunchFailure
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaEventCreate(cudaEvent_t*) "cudaEventCreate (C API)",
  -- * ::cudaEventCreateWithFlags, ::cudaEventRecord,
  -- * ::cudaEventSynchronize, ::cudaEventDestroy, ::cudaEventElapsedTime
  --  

   function cudaEventQuery (event : driver_types_h.cudaEvent_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2353
   pragma Import (C, cudaEventQuery, "cudaEventQuery");

  --*
  -- * \brief Waits for an event to complete
  -- *
  -- * Wait until the completion of all device work preceding the most recent
  -- * call to ::cudaEventRecord() (in the appropriate compute streams, as specified
  -- * by the arguments to ::cudaEventRecord()).
  -- *
  -- * If ::cudaEventRecord() has not been called on \p event, ::cudaSuccess is
  -- * returned immediately.
  -- *
  -- * Waiting for an event that was created with the ::cudaEventBlockingSync
  -- * flag will cause the calling CPU thread to block until the event has
  -- * been completed by the device.  If the ::cudaEventBlockingSync flag has
  -- * not been set, then the CPU thread will busy-wait until the event has
  -- * been completed by the device.
  -- *
  -- * \param event - Event to wait for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorLaunchFailure
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaEventCreate(cudaEvent_t*) "cudaEventCreate (C API)",
  -- * ::cudaEventCreateWithFlags, ::cudaEventRecord,
  -- * ::cudaEventQuery, ::cudaEventDestroy, ::cudaEventElapsedTime
  --  

   function cudaEventSynchronize (event : driver_types_h.cudaEvent_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2385
   pragma Import (C, cudaEventSynchronize, "cudaEventSynchronize");

  --*
  -- * \brief Destroys an event object
  -- *
  -- * Destroys the event specified by \p event.
  -- *
  -- * In case \p event has been recorded but has not yet been completed
  -- * when ::cudaEventDestroy() is called, the function will return immediately and 
  -- * the resources associated with \p event will be released automatically once
  -- * the device has completed \p event.
  -- *
  -- * \param event - Event to destroy
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorLaunchFailure
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaEventCreate(cudaEvent_t*) "cudaEventCreate (C API)",
  -- * ::cudaEventCreateWithFlags, ::cudaEventQuery,
  -- * ::cudaEventSynchronize, ::cudaEventRecord, ::cudaEventElapsedTime
  --  

   function cudaEventDestroy (event : driver_types_h.cudaEvent_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2410
   pragma Import (C, cudaEventDestroy, "cudaEventDestroy");

  --*
  -- * \brief Computes the elapsed time between events
  -- *
  -- * Computes the elapsed time between two events (in milliseconds with a
  -- * resolution of around 0.5 microseconds).
  -- *
  -- * If either event was last recorded in a non-NULL stream, the resulting time
  -- * may be greater than expected (even if both used the same stream handle). This
  -- * happens because the ::cudaEventRecord() operation takes place asynchronously
  -- * and there is no guarantee that the measured latency is actually just between
  -- * the two events. Any number of other different stream operations could execute
  -- * in between the two measured events, thus altering the timing in a significant
  -- * way.
  -- *
  -- * If ::cudaEventRecord() has not been called on either event, then
  -- * ::cudaErrorInvalidResourceHandle is returned. If ::cudaEventRecord() has been
  -- * called on both events but one or both of them has not yet been completed
  -- * (that is, ::cudaEventQuery() would return ::cudaErrorNotReady on at least one
  -- * of the events), ::cudaErrorNotReady is returned. If either event was created
  -- * with the ::cudaEventDisableTiming flag, then this function will return
  -- * ::cudaErrorInvalidResourceHandle.
  -- *
  -- * \param ms    - Time between \p start and \p end in ms
  -- * \param start - Starting event
  -- * \param end   - Ending event
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorNotReady,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorLaunchFailure
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaEventCreate(cudaEvent_t*) "cudaEventCreate (C API)",
  -- * ::cudaEventCreateWithFlags, ::cudaEventQuery,
  -- * ::cudaEventSynchronize, ::cudaEventDestroy, ::cudaEventRecord
  --  

   function cudaEventElapsedTime
     (ms : access float;
      start : driver_types_h.cudaEvent_t;
      c_end : driver_types_h.cudaEvent_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2451
   pragma Import (C, cudaEventElapsedTime, "cudaEventElapsedTime");

  --* @}  
  -- END CUDART_EVENT  
  --*
  -- * \defgroup CUDART_EXECUTION Execution Control
  -- *
  -- * ___MANBRIEF___ execution control functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the execution control functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * Some functions have overloaded C++ API template versions documented separately in the
  -- * \ref CUDART_HIGHLEVEL "C++ API Routines" module.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Launches a device function
  -- *
  -- * The function invokes kernel \p func on \p gridDim (\p gridDim.x × \p gridDim.y
  -- * × \p gridDim.z) grid of blocks. Each block contains \p blockDim (\p blockDim.x ×
  -- * \p blockDim.y × \p blockDim.z) threads.
  -- *
  -- * If the kernel has N parameters the \p args should point to array of N pointers.
  -- * Each pointer, from <tt>args[0]</tt> to <tt>args[N - 1]</tt>, point to the region
  -- * of memory from which the actual parameter will be copied.
  -- *
  -- * For templated functions, pass the function symbol as follows:
  -- * func_name<template_arg_0,...,template_arg_N>
  -- *
  -- * \p sharedMem sets the amount of dynamic shared memory that will be available to
  -- * each thread block.
  -- *
  -- * \p stream specifies a stream the invocation is associated to.
  -- *
  -- * \param func        - Device function symbol
  -- * \param gridDim     - Grid dimentions
  -- * \param blockDim    - Block dimentions
  -- * \param args        - Arguments
  -- * \param sharedMem   - Shared memory
  -- * \param stream      - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDeviceFunction,
  -- * ::cudaErrorInvalidConfiguration,
  -- * ::cudaErrorLaunchFailure,
  -- * ::cudaErrorLaunchTimeout,
  -- * ::cudaErrorLaunchOutOfResources,
  -- * ::cudaErrorSharedObjectInitFailed
  -- * \note_null_stream
  -- * \notefnerr
  -- *
  -- * \ref ::cudaLaunchKernel(const T *func, dim3 gridDim, dim3 blockDim, void **args, size_t sharedMem, cudaStream_t stream) "cudaLaunchKernel (C++ API)"
  --  

   function cudaLaunchKernel
     (func : System.Address;
      gridDim : vector_types_h.Class_dim3.dim3;
      blockDim : vector_types_h.Class_dim3.dim3;
      args : System.Address;
      sharedMem : stddef_h.size_t;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2510
   pragma Import (C, cudaLaunchKernel, "cudaLaunchKernel");

  --*
  -- * \brief Sets the preferred cache configuration for a device function
  -- *
  -- * On devices where the L1 cache and shared memory use the same hardware
  -- * resources, this sets through \p cacheConfig the preferred cache configuration
  -- * for the function specified via \p func. This is only a preference. The
  -- * runtime will use the requested configuration if possible, but it is free to
  -- * choose a different configuration if required to execute \p func.
  -- *
  -- * \p func is a device function symbol and must be declared as a
  -- * \c __global__ function. If the specified function does not exist,
  -- * then ::cudaErrorInvalidDeviceFunction is returned. For templated functions,
  -- * pass the function symbol as follows: func_name<template_arg_0,...,template_arg_N>
  -- *
  -- * This setting does nothing on devices where the size of the L1 cache and
  -- * shared memory are fixed.
  -- *
  -- * Launching a kernel with a different preference than the most recent
  -- * preference setting may insert a device-side synchronization point.
  -- *
  -- * The supported cache configurations are:
  -- * - ::cudaFuncCachePreferNone: no preference for shared memory or L1 (default)
  -- * - ::cudaFuncCachePreferShared: prefer larger shared memory and smaller L1 cache
  -- * - ::cudaFuncCachePreferL1: prefer larger L1 cache and smaller shared memory
  -- * - ::cudaFuncCachePreferEqual: prefer equal size L1 cache and shared memory
  -- *
  -- * \param func        - Device function symbol
  -- * \param cacheConfig - Requested cache configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidDeviceFunction
  -- * \notefnerr
  -- * \note_string_api_deprecation2
  -- *
  -- * \sa ::cudaConfigureCall,
  -- * \ref ::cudaFuncSetCacheConfig(T*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C++ API)",
  -- * \ref ::cudaFuncGetAttributes(struct cudaFuncAttributes*, const void*) "cudaFuncGetAttributes (C API)",
  -- * \ref ::cudaLaunchKernel(const void *func, dim3 gridDim, dim3 blockDim, void **args, size_t sharedMem, cudaStream_t stream) "cudaLaunchKernel (C API)",
  -- * ::cudaSetDoubleForDevice,
  -- * ::cudaSetDoubleForHost,
  -- * \ref ::cudaSetupArgument(const void*, size_t, size_t) "cudaSetupArgument (C API)",
  -- * ::cudaThreadGetCacheConfig,
  -- * ::cudaThreadSetCacheConfig
  --  

   function cudaFuncSetCacheConfig (func : System.Address; cacheConfig : driver_types_h.cudaFuncCache) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2560
   pragma Import (C, cudaFuncSetCacheConfig, "cudaFuncSetCacheConfig");

  --*
  -- * \brief Sets the shared memory configuration for a device function
  -- *
  -- * On devices with configurable shared memory banks, this function will 
  -- * force all subsequent launches of the specified device function to have
  -- * the given shared memory bank size configuration. On any given launch of the
  -- * function, the shared memory configuration of the device will be temporarily
  -- * changed if needed to suit the function's preferred configuration. Changes in
  -- * shared memory configuration between subsequent launches of functions, 
  -- * may introduce a device side synchronization point.
  -- *
  -- * Any per-function setting of shared memory bank size set via 
  -- * ::cudaFuncSetSharedMemConfig will override the device wide setting set by
  -- * ::cudaDeviceSetSharedMemConfig.
  -- *
  -- * Changing the shared memory bank size will not increase shared memory usage
  -- * or affect occupancy of kernels, but may have major effects on performance. 
  -- * Larger bank sizes will allow for greater potential bandwidth to shared memory,
  -- * but will change what kinds of accesses to shared memory will result in bank 
  -- * conflicts.
  -- *
  -- * This function will do nothing on devices with fixed shared memory bank size.
  -- *
  -- * For templated functions, pass the function symbol as follows:
  -- * func_name<template_arg_0,...,template_arg_N>
  -- *
  -- * The supported bank configurations are:
  -- * - ::cudaSharedMemBankSizeDefault: use the device's shared memory configuration
  -- *   when launching this function.
  -- * - ::cudaSharedMemBankSizeFourByte: set shared memory bank width to be 
  -- *   four bytes natively when launching this function.
  -- * - ::cudaSharedMemBankSizeEightByte: set shared memory bank width to be eight 
  -- *   bytes natively when launching this function.
  -- *
  -- * \param func   - Device function symbol
  -- * \param config - Requested shared memory configuration
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidDeviceFunction,
  -- * ::cudaErrorInvalidValue,
  -- * \notefnerr
  -- * \note_string_api_deprecation2
  -- *
  -- * \sa ::cudaConfigureCall,
  -- * ::cudaDeviceSetSharedMemConfig,
  -- * ::cudaDeviceGetSharedMemConfig,
  -- * ::cudaDeviceSetCacheConfig,
  -- * ::cudaDeviceGetCacheConfig,
  -- * ::cudaFuncSetCacheConfig
  --  

   function cudaFuncSetSharedMemConfig (func : System.Address; config : driver_types_h.cudaSharedMemConfig) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2614
   pragma Import (C, cudaFuncSetSharedMemConfig, "cudaFuncSetSharedMemConfig");

  --*
  -- * \brief Find out attributes for a given function
  -- *
  -- * This function obtains the attributes of a function specified via \p func.
  -- * \p func is a device function symbol and must be declared as a
  -- * \c __global__ function. The fetched attributes are placed in \p attr.
  -- * If the specified function does not exist, then
  -- * ::cudaErrorInvalidDeviceFunction is returned. For templated functions, pass
  -- * the function symbol as follows: func_name<template_arg_0,...,template_arg_N>
  -- *
  -- * Note that some function attributes such as
  -- * \ref ::cudaFuncAttributes::maxThreadsPerBlock "maxThreadsPerBlock"
  -- * may vary based on the device that is currently being used.
  -- *
  -- * \param attr - Return pointer to function's attributes
  -- * \param func - Device function symbol
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidDeviceFunction
  -- * \notefnerr
  -- * \note_string_api_deprecation2
  -- *
  -- * \sa ::cudaConfigureCall,
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncGetAttributes(struct cudaFuncAttributes*, T*) "cudaFuncGetAttributes (C++ API)",
  -- * \ref ::cudaLaunchKernel(const void *func, dim3 gridDim, dim3 blockDim, void **args, size_t sharedMem, cudaStream_t stream) "cudaLaunchKernel (C API)",
  -- * ::cudaSetDoubleForDevice,
  -- * ::cudaSetDoubleForHost,
  -- * \ref ::cudaSetupArgument(const void*, size_t, size_t) "cudaSetupArgument (C API)"
  --  

   function cudaFuncGetAttributes (attr : access driver_types_h.cudaFuncAttributes; func : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2648
   pragma Import (C, cudaFuncGetAttributes, "cudaFuncGetAttributes");

  --*
  -- * \brief Converts a double argument to be executed on a device
  -- *
  -- * \param d - Double to convert
  -- *
  -- * \deprecated This function is deprecated as of CUDA 7.5
  -- *
  -- * Converts the double value of \p d to an internal float representation if
  -- * the device does not support double arithmetic. If the device does natively
  -- * support doubles, then this function does nothing.
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \ref ::cudaLaunch(const void*) "cudaLaunch (C API)",
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncGetAttributes(struct cudaFuncAttributes*, const void*) "cudaFuncGetAttributes (C API)",
  -- * ::cudaSetDoubleForHost,
  -- * \ref ::cudaSetupArgument(const void*, size_t, size_t) "cudaSetupArgument (C API)"
  --  

   function cudaSetDoubleForDevice (d : access double) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2671
   pragma Import (C, cudaSetDoubleForDevice, "cudaSetDoubleForDevice");

  --*
  -- * \brief Converts a double argument after execution on a device
  -- *
  -- * \deprecated This function is deprecated as of CUDA 7.5
  -- *
  -- * Converts the double value of \p d from a potentially internal float
  -- * representation if the device does not support double arithmetic. If the
  -- * device does natively support doubles, then this function does nothing.
  -- *
  -- * \param d - Double to convert
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \ref ::cudaLaunch(const void*) "cudaLaunch (C API)",
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncGetAttributes(struct cudaFuncAttributes*, const void*) "cudaFuncGetAttributes (C API)",
  -- * ::cudaSetDoubleForDevice,
  -- * \ref ::cudaSetupArgument(const void*, size_t, size_t) "cudaSetupArgument (C API)"
  --  

   function cudaSetDoubleForHost (d : access double) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2694
   pragma Import (C, cudaSetDoubleForHost, "cudaSetDoubleForHost");

  --* @}  
  -- END CUDART_EXECUTION  
  --*
  -- * \defgroup CUDART_OCCUPANCY Occupancy
  -- *
  -- * ___MANBRIEF___ occupancy calculation functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the occupancy calculation functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * Besides the occupancy calculator functions
  -- * (\ref ::cudaOccupancyMaxActiveBlocksPerMultiprocessor and \ref ::cudaOccupancyMaxActiveBlocksPerMultiprocessorWithFlags),
  -- * there are also C++ only occupancy-based launch configuration functions documented in
  -- * \ref CUDART_HIGHLEVEL "C++ API Routines" module.
  -- *
  -- * See
  -- * \ref ::cudaOccupancyMaxPotentialBlockSize(int*, int*, T, size_t, int) "cudaOccupancyMaxPotentialBlockSize (C++ API)",
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeWithFlags(int*, int*, T, size_t, int, unsigned int) "cudaOccupancyMaxPotentialBlockSize (C++ API)",
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeVariableSMem(int*, int*, T, UnaryFunction, int) "cudaOccupancyMaxPotentialBlockSizeVariableSMem (C++ API)",
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeVariableSMemWithFlags(int*, int*, T, UnaryFunction, int, unsigned int) "cudaOccupancyMaxPotentialBlockSizeVariableSMem (C++ API)",
  -- *
  -- * @{
  --  

  --*
  -- * \brief Returns occupancy for a device function
  -- *
  -- * Returns in \p *numBlocks the maximum number of active blocks per
  -- * streaming multiprocessor for the device function.
  -- *
  -- * \param numBlocks       - Returned occupancy
  -- * \param func            - Kernel function for which occupancy is calculated
  -- * \param blockSize       - Block size the kernel is intended to be launched with
  -- * \param dynamicSMemSize - Per-block dynamic shared memory usage intended, in bytes
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorCudartUnloading,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorInvalidDeviceFunction,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorUnknown,
  -- * \notefnerr
  -- *
  -- * \sa ::cudaOccupancyMaxActiveBlocksPerMultiprocessorWithFlags,
  -- * \ref ::cudaOccupancyMaxPotentialBlockSize(int*, int*, T, size_t, int) "cudaOccupancyMaxPotentialBlockSize (C++ API)",
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeWithFlags(int*, int*, T, size_t, int, unsigned int) "cudaOccupancyMaxPotentialBlockSizeWithFlags (C++ API)",
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeVariableSMem(int*, int*, T, UnaryFunction, int) "cudaOccupancyMaxPotentialBlockSizeVariableSMem (C++ API)"
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeVariableSMemWithFlags(int*, int*, T, UnaryFunction, int, unsigned int) "cudaOccupancyMaxPotentialBlockSizeVariableSMemWithFlags (C++ API)"
  --  

   function cudaOccupancyMaxActiveBlocksPerMultiprocessor
     (numBlocks : access int;
      func : System.Address;
      blockSize : int;
      dynamicSMemSize : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2750
   pragma Import (C, cudaOccupancyMaxActiveBlocksPerMultiprocessor, "cudaOccupancyMaxActiveBlocksPerMultiprocessor");

  --*
  -- * \brief Returns occupancy for a device function with the specified flags
  -- *
  -- * Returns in \p *numBlocks the maximum number of active blocks per
  -- * streaming multiprocessor for the device function.
  -- *
  -- * The \p flags parameter controls how special cases are handled. Valid flags include:
  -- *
  -- * - ::cudaOccupancyDefault: keeps the default behavior as
  -- *   ::cudaOccupancyMaxActiveBlocksPerMultiprocessor
  -- *
  -- * - ::cudaOccupancyDisableCachingOverride: This flag suppresses the default behavior
  -- *   on platform where global caching affects occupancy. On such platforms, if caching
  -- *   is enabled, but per-block SM resource usage would result in zero occupancy, the
  -- *   occupancy calculator will calculate the occupancy as if caching is disabled.
  -- *   Setting this flag makes the occupancy calculator to return 0 in such cases.
  -- *   More information can be found about this feature in the "Unified L1/Texture Cache"
  -- *   section of the Maxwell tuning guide.
  -- *
  -- * \param numBlocks       - Returned occupancy
  -- * \param func            - Kernel function for which occupancy is calculated
  -- * \param blockSize       - Block size the kernel is intended to be launched with
  -- * \param dynamicSMemSize - Per-block dynamic shared memory usage intended, in bytes
  -- * \param flags           - Requested behavior for the occupancy calculator
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorCudartUnloading,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorInvalidDeviceFunction,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorUnknown,
  -- * \notefnerr
  -- *
  -- * \sa ::cudaOccupancyMaxActiveBlocksPerMultiprocessor,
  -- * \ref ::cudaOccupancyMaxPotentialBlockSize(int*, int*, T, size_t, int) "cudaOccupancyMaxPotentialBlockSize (C++ API)",
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeWithFlags(int*, int*, T, size_t, int, unsigned int) "cudaOccupancyMaxPotentialBlockSizeWithFlags (C++ API)",
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeVariableSMem(int*, int*, T, UnaryFunction, int) "cudaOccupancyMaxPotentialBlockSizeVariableSMem (C++ API)"
  -- * \ref ::cudaOccupancyMaxPotentialBlockSizeVariableSMemWithFlags(int*, int*, T, UnaryFunction, int, unsigned int) "cudaOccupancyMaxPotentialBlockSizeVariableSMemWithFlags (C++ API)"
  --  

   function cudaOccupancyMaxActiveBlocksPerMultiprocessorWithFlags
     (numBlocks : access int;
      func : System.Address;
      blockSize : int;
      dynamicSMemSize : stddef_h.size_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2794
   pragma Import (C, cudaOccupancyMaxActiveBlocksPerMultiprocessorWithFlags, "cudaOccupancyMaxActiveBlocksPerMultiprocessorWithFlags");

  --* @}  
  -- END CUDA_OCCUPANCY  
  --*
  -- * \defgroup CUDART_EXECUTION_DEPRECATED Execution Control [DEPRECATED]
  -- *
  -- * ___MANBRIEF___ deprecated execution control functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the deprecated execution control functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * Some functions have overloaded C++ API template versions documented separately in the
  -- * \ref CUDART_HIGHLEVEL "C++ API Routines" module.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Configure a device-launch
  -- *
  -- * \deprecated This function is deprecated as of CUDA 7.0
  -- *
  -- * Specifies the grid and block dimensions for the device call to be executed
  -- * similar to the execution configuration syntax. ::cudaConfigureCall() is
  -- * stack based. Each call pushes data on top of an execution stack. This data
  -- * contains the dimension for the grid and thread blocks, together with any
  -- * arguments for the call.
  -- *
  -- * \param gridDim   - Grid dimensions
  -- * \param blockDim  - Block dimensions
  -- * \param sharedMem - Shared memory
  -- * \param stream    - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidConfiguration
  -- * \note_null_stream
  -- * \notefnerr
  -- *
  -- * \ref ::cudaLaunchKernel(const void *func, dim3 gridDim, dim3 blockDim, void **args, size_t sharedMem, cudaStream_t stream) "cudaLaunchKernel (C API)",
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncGetAttributes(struct cudaFuncAttributes*, const void*) "cudaFuncGetAttributes (C API)",
  -- * \ref ::cudaLaunch(const void*) "cudaLaunch (C API)",
  -- * ::cudaSetDoubleForDevice,
  -- * ::cudaSetDoubleForHost,
  -- * \ref ::cudaSetupArgument(const void*, size_t, size_t) "cudaSetupArgument (C API)",
  --  

   function cudaConfigureCall
     (gridDim : vector_types_h.Class_dim3.dim3;
      blockDim : vector_types_h.Class_dim3.dim3;
      sharedMem : stddef_h.size_t;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2845
   pragma Import (C, cudaConfigureCall, "cudaConfigureCall");

  --*
  -- * \brief Configure a device launch
  -- *
  -- * \deprecated This function is deprecated as of CUDA 7.0
  -- *
  -- * Pushes \p size bytes of the argument pointed to by \p arg at \p offset
  -- * bytes from the start of the parameter passing area, which starts at
  -- * offset 0. The arguments are stored in the top of the execution stack.
  -- * \ref ::cudaSetupArgument(const void*, size_t, size_t) "cudaSetupArgument()"
  -- * must be preceded by a call to ::cudaConfigureCall().
  -- *
  -- * \param arg    - Argument to push for a kernel launch
  -- * \param size   - Size of argument
  -- * \param offset - Offset in argument stack to push new arg
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \ref ::cudaLaunchKernel(const void *func, dim3 gridDim, dim3 blockDim, void **args, size_t sharedMem, cudaStream_t stream) "cudaLaunchKernel (C API)",
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncGetAttributes(struct cudaFuncAttributes*, const void*) "cudaFuncGetAttributes (C API)",
  -- * \ref ::cudaLaunch(const void*) "cudaLaunch (C API)",
  -- * ::cudaSetDoubleForDevice,
  -- * ::cudaSetDoubleForHost,
  -- * \ref ::cudaSetupArgument(T, size_t) "cudaSetupArgument (C++ API)",
  --  

   function cudaSetupArgument
     (arg : System.Address;
      size : stddef_h.size_t;
      offset : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2874
   pragma Import (C, cudaSetupArgument, "cudaSetupArgument");

  --*
  -- * \brief Launches a device function
  -- *
  -- * \deprecated This function is deprecated as of CUDA 7.0
  -- *
  -- * Launches the function \p func on the device. The parameter \p func must
  -- * be a device function symbol. The parameter specified by \p func must be
  -- * declared as a \p __global__ function. For templated functions, pass the
  -- * function symbol as follows: func_name<template_arg_0,...,template_arg_N>
  -- * \ref ::cudaLaunch(const void*) "cudaLaunch()" must be preceded by a call to
  -- * ::cudaConfigureCall() since it pops the data that was pushed by
  -- * ::cudaConfigureCall() from the execution stack.
  -- *
  -- * \param func - Device function symbol
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDeviceFunction,
  -- * ::cudaErrorInvalidConfiguration,
  -- * ::cudaErrorLaunchFailure,
  -- * ::cudaErrorLaunchTimeout,
  -- * ::cudaErrorLaunchOutOfResources,
  -- * ::cudaErrorSharedObjectInitFailed
  -- * \notefnerr
  -- * \note_string_api_deprecation_50
  -- *
  -- * \ref ::cudaLaunchKernel(const void *func, dim3 gridDim, dim3 blockDim, void **args, size_t sharedMem, cudaStream_t stream) "cudaLaunchKernel (C API)",
  -- * \ref ::cudaFuncSetCacheConfig(const void*, enum cudaFuncCache) "cudaFuncSetCacheConfig (C API)",
  -- * \ref ::cudaFuncGetAttributes(struct cudaFuncAttributes*, const void*) "cudaFuncGetAttributes (C API)",
  -- * \ref ::cudaLaunch(T*) "cudaLaunch (C++ API)",
  -- * ::cudaSetDoubleForDevice,
  -- * ::cudaSetDoubleForHost,
  -- * \ref ::cudaSetupArgument(const void*, size_t, size_t) "cudaSetupArgument (C API)",
  -- * ::cudaThreadGetCacheConfig,
  -- * ::cudaThreadSetCacheConfig
  --  

   function cudaLaunch (func : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:2912
   pragma Import (C, cudaLaunch, "cudaLaunch");

  --* @}  
  -- END CUDART_EXECUTION_DEPRECATED  
  --*
  -- * \defgroup CUDART_MEMORY Memory Management
  -- *
  -- * ___MANBRIEF___ memory management functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the memory management functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * Some functions have overloaded C++ API template versions documented separately in the
  -- * \ref CUDART_HIGHLEVEL "C++ API Routines" module.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Allocates memory that will be automatically managed by the Unified Memory system
  -- *
  -- * Allocates \p size bytes of managed memory on the device and returns in
  -- * \p *devPtr a pointer to the allocated memory. If the device doesn't support
  -- * allocating managed memory, ::cudaErrorNotSupported is returned. Support
  -- * for managed memory can be queried using the device attribute
  -- * ::cudaDevAttrManagedMemory. The allocated memory is suitably
  -- * aligned for any kind of variable. The memory is not cleared. If \p size
  -- * is 0, ::cudaMallocManaged returns ::cudaErrorInvalidValue. The pointer
  -- * is valid on the CPU and on all GPUs in the system that support managed memory.
  -- * All accesses to this pointer must obey the Unified Memory programming model.
  -- *
  -- * \p flags specifies the default stream association for this allocation.
  -- * \p flags must be one of ::cudaMemAttachGlobal or ::cudaMemAttachHost. The
  -- * default value for \p flags is ::cudaMemAttachGlobal.
  -- * If ::cudaMemAttachGlobal is specified, then this memory is accessible from
  -- * any stream on any device. If ::cudaMemAttachHost is specified, then the
  -- * allocation should not be accessed from devices that have a zero value for the
  -- * device attribute ::cudaDevAttrConcurrentManagedAccess; an explicit call to
  -- * ::cudaStreamAttachMemAsync will be required to enable access on such devices.
  -- *
  -- * If the association is later changed via ::cudaStreamAttachMemAsync to
  -- * a single stream, the default association, as specifed during ::cudaMallocManaged,
  -- * is restored when that stream is destroyed. For __managed__ variables, the
  -- * default association is always ::cudaMemAttachGlobal. Note that destroying a
  -- * stream is an asynchronous operation, and as a result, the change to default
  -- * association won't happen until all work in the stream has completed.
  -- *
  -- * Memory allocated with ::cudaMallocManaged should be released with ::cudaFree.
  -- *
  -- * Device memory oversubscription is possible for GPUs that have a non-zero value for the
  -- * device attribute ::cudaDevAttrConcurrentManagedAccess. Managed memory on
  -- * such GPUs may be evicted from device memory to host memory at any time by the Unified
  -- * Memory driver in order to make room for other allocations.
  -- *
  -- * In a multi-GPU system where all GPUs have a non-zero value for the device attribute
  -- * ::cudaDevAttrConcurrentManagedAccess, managed memory may not be populated when this
  -- * API returns and instead may be populated on access. In such systems, managed memory can
  -- * migrate to any processor's memory at any time. The Unified Memory driver will employ heuristics to
  -- * maintain data locality and prevent excessive page faults to the extent possible. The application
  -- * can also guide the driver about memory usage patterns via ::cudaMemAdvise. The application
  -- * can also explicitly migrate memory to a desired processor's memory via
  -- * ::cudaMemPrefetchAsync.
  -- *
  -- * In a multi-GPU system where all of the GPUs have a zero value for the device attribute
  -- * ::cudaDevAttrConcurrentManagedAccess and all the GPUs have peer-to-peer support
  -- * with each other, the physical storage for managed memory is created on the GPU which is active
  -- * at the time ::cudaMallocManaged is called. All other GPUs will reference the data at reduced
  -- * bandwidth via peer mappings over the PCIe bus. The Unified Memory driver does not migrate
  -- * memory among such GPUs.
  -- *
  -- * In a multi-GPU system where not all GPUs have peer-to-peer support with each other and
  -- * where the value of the device attribute ::cudaDevAttrConcurrentManagedAccess
  -- * is zero for at least one of those GPUs, the location chosen for physical storage of managed
  -- * memory is system-dependent.
  -- * - On Linux, the location chosen will be device memory as long as the current set of active
  -- * contexts are on devices that either have peer-to-peer support with each other or have a
  -- * non-zero value for the device attribute ::cudaDevAttrConcurrentManagedAccess.
  -- * If there is an active context on a GPU that does not have a non-zero value for that device
  -- * attribute and it does not have peer-to-peer support with the other devices that have active
  -- * contexts on them, then the location for physical storage will be 'zero-copy' or host memory.
  -- * Note that this means that managed memory that is located in device memory is migrated to
  -- * host memory if a new context is created on a GPU that doesn't have a non-zero value for
  -- * the device attribute and does not support peer-to-peer with at least one of the other devices
  -- * that has an active context. This in turn implies that context creation may fail if there is
  -- * insufficient host memory to migrate all managed allocations.
  -- * - On Windows, the physical storage is always created in 'zero-copy' or host memory.
  -- * All GPUs will reference the data at reduced bandwidth over the PCIe bus. In these
  -- * circumstances, use of the environment variable CUDA_VISIBLE_DEVICES is recommended to
  -- * restrict CUDA to only use those GPUs that have peer-to-peer support.
  -- * Alternatively, users can also set CUDA_MANAGED_FORCE_DEVICE_ALLOC to a non-zero
  -- * value to force the driver to always use device memory for physical storage.
  -- * When this environment variable is set to a non-zero value, all devices used in
  -- * that process that support managed memory have to be peer-to-peer compatible
  -- * with each other. The error ::cudaErrorInvalidDevice will be returned if a device
  -- * that supports managed memory is used and it is not peer-to-peer compatible with
  -- * any of the other managed memory supporting devices that were previously used in
  -- * that process, even if ::cudaDeviceReset has been called on those devices. These
  -- * environment variables are described in the CUDA programming guide under the
  -- * "CUDA environment variables" section.
  -- *
  -- * \param devPtr - Pointer to allocated device memory
  -- * \param size   - Requested allocation size in bytes
  -- * \param flags  - Must be either ::cudaMemAttachGlobal or ::cudaMemAttachHost (defaults to ::cudaMemAttachGlobal)
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * ::cudaErrorNotSupported
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaMallocPitch, ::cudaFree, ::cudaMallocArray, ::cudaFreeArray,
  -- * ::cudaMalloc3D, ::cudaMalloc3DArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc, ::cudaDeviceGetAttribute, ::cudaStreamAttachMemAsync
  --  

   function cudaMallocManaged
     (devPtr : System.Address;
      size : stddef_h.size_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3030
   pragma Import (C, cudaMallocManaged, "cudaMallocManaged");

  --*
  -- * \brief Allocate memory on the device
  -- *
  -- * Allocates \p size bytes of linear memory on the device and returns in
  -- * \p *devPtr a pointer to the allocated memory. The allocated memory is
  -- * suitably aligned for any kind of variable. The memory is not cleared.
  -- * ::cudaMalloc() returns ::cudaErrorMemoryAllocation in case of failure.
  -- *
  -- * The device version of ::cudaFree cannot be used with a \p *devPtr
  -- * allocated using the host API, and vice versa.
  -- *
  -- * \param devPtr - Pointer to allocated device memory
  -- * \param size   - Requested allocation size in bytes
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- *
  -- * \sa ::cudaMallocPitch, ::cudaFree, ::cudaMallocArray, ::cudaFreeArray,
  -- * ::cudaMalloc3D, ::cudaMalloc3DArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc
  --  

   function cudaMalloc (devPtr : System.Address; size : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3056
   pragma Import (C, cudaMalloc, "cudaMalloc");

  --*
  -- * \brief Allocates page-locked memory on the host
  -- *
  -- * Allocates \p size bytes of host memory that is page-locked and accessible
  -- * to the device. The driver tracks the virtual memory ranges allocated with
  -- * this function and automatically accelerates calls to functions such as
  -- * ::cudaMemcpy*(). Since the memory can be accessed directly by the device,
  -- * it can be read or written with much higher bandwidth than pageable memory
  -- * obtained with functions such as ::malloc(). Allocating excessive amounts of
  -- * memory with ::cudaMallocHost() may degrade system performance, since it
  -- * reduces the amount of memory available to the system for paging. As a
  -- * result, this function is best used sparingly to allocate staging areas for
  -- * data exchange between host and device.
  -- *
  -- * \param ptr  - Pointer to allocated host memory
  -- * \param size - Requested allocation size in bytes
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc, ::cudaMallocPitch, ::cudaMallocArray, ::cudaMalloc3D,
  -- * ::cudaMalloc3DArray, ::cudaHostAlloc, ::cudaFree, ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t, unsigned int) "cudaMallocHost (C++ API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc
  --  

   function cudaMallocHost (ptr : System.Address; size : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3085
   pragma Import (C, cudaMallocHost, "cudaMallocHost");

  --*
  -- * \brief Allocates pitched memory on the device
  -- *
  -- * Allocates at least \p width (in bytes) * \p height bytes of linear memory
  -- * on the device and returns in \p *devPtr a pointer to the allocated memory.
  -- * The function may pad the allocation to ensure that corresponding pointers
  -- * in any given row will continue to meet the alignment requirements for
  -- * coalescing as the address is updated from row to row. The pitch returned in
  -- * \p *pitch by ::cudaMallocPitch() is the width in bytes of the allocation.
  -- * The intended usage of \p pitch is as a separate parameter of the allocation,
  -- * used to compute addresses within the 2D array. Given the row and column of
  -- * an array element of type \p T, the address is computed as:
  -- * \code
  --    T* pElement = (T*)((char*)BaseAddress + Row * pitch) + Column;
  --   \endcode
  -- *
  -- * For allocations of 2D arrays, it is recommended that programmers consider
  -- * performing pitch allocations using ::cudaMallocPitch(). Due to pitch
  -- * alignment restrictions in the hardware, this is especially true if the
  -- * application will be performing 2D memory copies between different regions
  -- * of device memory (whether linear memory or CUDA arrays).
  -- *
  -- * \param devPtr - Pointer to allocated pitched device memory
  -- * \param pitch  - Pitch for allocation
  -- * \param width  - Requested pitched allocation width (in bytes)
  -- * \param height - Requested pitched allocation height
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc, ::cudaFree, ::cudaMallocArray, ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaMalloc3D, ::cudaMalloc3DArray,
  -- * ::cudaHostAlloc
  --  

   function cudaMallocPitch
     (devPtr : System.Address;
      pitch : access stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3124
   pragma Import (C, cudaMallocPitch, "cudaMallocPitch");

  --*
  -- * \brief Allocate an array on the device
  -- *
  -- * Allocates a CUDA array according to the ::cudaChannelFormatDesc structure
  -- * \p desc and returns a handle to the new CUDA array in \p *array.
  -- *
  -- * The ::cudaChannelFormatDesc is defined as:
  -- * \code
  --    struct cudaChannelFormatDesc {
  --        int x, y, z, w;
  --    enum cudaChannelFormatKind f;
  --    };
  --    \endcode
  -- * where ::cudaChannelFormatKind is one of ::cudaChannelFormatKindSigned,
  -- * ::cudaChannelFormatKindUnsigned, or ::cudaChannelFormatKindFloat.
  -- *
  -- * The \p flags parameter enables different options to be specified that affect
  -- * the allocation, as follows.
  -- * - ::cudaArrayDefault: This flag's value is defined to be 0 and provides default array allocation
  -- * - ::cudaArraySurfaceLoadStore: Allocates an array that can be read from or written to using a surface reference
  -- * - ::cudaArrayTextureGather: This flag indicates that texture gather operations will be performed on the array.
  -- *
  -- * \p width and \p height must meet certain size requirements. See ::cudaMalloc3DArray() for more details.
  -- *
  -- * \param array  - Pointer to allocated array in device memory
  -- * \param desc   - Requested channel format
  -- * \param width  - Requested array allocation width
  -- * \param height - Requested array allocation height
  -- * \param flags  - Requested properties of allocated array
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc, ::cudaMallocPitch, ::cudaFree, ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaMalloc3D, ::cudaMalloc3DArray,
  -- * ::cudaHostAlloc
  --  

   function cudaMallocArray
     (c_array : System.Address;
      desc : access constant driver_types_h.cudaChannelFormatDesc;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3166
   pragma Import (C, cudaMallocArray, "cudaMallocArray");

  --*
  -- * \brief Frees memory on the device
  -- *
  -- * Frees the memory space pointed to by \p devPtr, which must have been
  -- * returned by a previous call to ::cudaMalloc() or ::cudaMallocPitch().
  -- * Otherwise, or if ::cudaFree(\p devPtr) has already been called before,
  -- * an error is returned. If \p devPtr is 0, no operation is performed.
  -- * ::cudaFree() returns ::cudaErrorInvalidDevicePointer in case of failure.
  -- *
  -- * The device version of ::cudaFree cannot be used with a \p *devPtr
  -- * allocated using the host API, and vice versa.
  -- *
  -- * \param devPtr - Device pointer to memory to free
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc, ::cudaMallocPitch, ::cudaMallocArray, ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaMalloc3D, ::cudaMalloc3DArray,
  -- * ::cudaHostAlloc
  --  

   function cudaFree (devPtr : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3193
   pragma Import (C, cudaFree, "cudaFree");

  --*
  -- * \brief Frees page-locked memory
  -- *
  -- * Frees the memory space pointed to by \p hostPtr, which must have been
  -- * returned by a previous call to ::cudaMallocHost() or ::cudaHostAlloc().
  -- *
  -- * \param ptr - Pointer to memory to free
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc, ::cudaMallocPitch, ::cudaFree, ::cudaMallocArray,
  -- * ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaMalloc3D, ::cudaMalloc3DArray, ::cudaHostAlloc
  --  

   function cudaFreeHost (ptr : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3213
   pragma Import (C, cudaFreeHost, "cudaFreeHost");

  --*
  -- * \brief Frees an array on the device
  -- *
  -- * Frees the CUDA array \p array, which must have been * returned by a
  -- * previous call to ::cudaMallocArray(). If ::cudaFreeArray(\p array) has
  -- * already been called before, ::cudaErrorInvalidValue is returned. If
  -- * \p devPtr is 0, no operation is performed.
  -- *
  -- * \param array - Pointer to array to free
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc, ::cudaMallocPitch, ::cudaFree, ::cudaMallocArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc
  --  

   function cudaFreeArray (c_array : driver_types_h.cudaArray_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3235
   pragma Import (C, cudaFreeArray, "cudaFreeArray");

  --*
  -- * \brief Frees a mipmapped array on the device
  -- *
  -- * Frees the CUDA mipmapped array \p mipmappedArray, which must have been 
  -- * returned by a previous call to ::cudaMallocMipmappedArray(). 
  -- * If ::cudaFreeMipmappedArray(\p mipmappedArray) has already been called before,
  -- * ::cudaErrorInvalidValue is returned.
  -- *
  -- * \param mipmappedArray - Pointer to mipmapped array to free
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInitializationError
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc, ::cudaMallocPitch, ::cudaFree, ::cudaMallocArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc
  --  

   function cudaFreeMipmappedArray (mipmappedArray : driver_types_h.cudaMipmappedArray_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3257
   pragma Import (C, cudaFreeMipmappedArray, "cudaFreeMipmappedArray");

  --*
  -- * \brief Allocates page-locked memory on the host
  -- *
  -- * Allocates \p size bytes of host memory that is page-locked and accessible
  -- * to the device. The driver tracks the virtual memory ranges allocated with
  -- * this function and automatically accelerates calls to functions such as
  -- * ::cudaMemcpy(). Since the memory can be accessed directly by the device, it
  -- * can be read or written with much higher bandwidth than pageable memory
  -- * obtained with functions such as ::malloc(). Allocating excessive amounts of
  -- * pinned memory may degrade system performance, since it reduces the amount
  -- * of memory available to the system for paging. As a result, this function is
  -- * best used sparingly to allocate staging areas for data exchange between host
  -- * and device.
  -- *
  -- * The \p flags parameter enables different options to be specified that affect
  -- * the allocation, as follows.
  -- * - ::cudaHostAllocDefault: This flag's value is defined to be 0 and causes
  -- * ::cudaHostAlloc() to emulate ::cudaMallocHost().
  -- * - ::cudaHostAllocPortable: The memory returned by this call will be
  -- * considered as pinned memory by all CUDA contexts, not just the one that
  -- * performed the allocation.
  -- * - ::cudaHostAllocMapped: Maps the allocation into the CUDA address space.
  -- * The device pointer to the memory may be obtained by calling
  -- * ::cudaHostGetDevicePointer().
  -- * - ::cudaHostAllocWriteCombined: Allocates the memory as write-combined (WC).
  -- * WC memory can be transferred across the PCI Express bus more quickly on some
  -- * system configurations, but cannot be read efficiently by most CPUs.  WC
  -- * memory is a good option for buffers that will be written by the CPU and read
  -- * by the device via mapped pinned memory or host->device transfers.
  -- *
  -- * All of these flags are orthogonal to one another: a developer may allocate
  -- * memory that is portable, mapped and/or write-combined with no restrictions.
  -- *
  -- * ::cudaSetDeviceFlags() must have been called with the ::cudaDeviceMapHost
  -- * flag in order for the ::cudaHostAllocMapped flag to have any effect.
  -- *
  -- * The ::cudaHostAllocMapped flag may be specified on CUDA contexts for devices
  -- * that do not support mapped pinned memory. The failure is deferred to
  -- * ::cudaHostGetDevicePointer() because the memory may be mapped into other
  -- * CUDA contexts via the ::cudaHostAllocPortable flag.
  -- *
  -- * Memory allocated by this function must be freed with ::cudaFreeHost().
  -- *
  -- * \param pHost - Device pointer to allocated memory
  -- * \param size  - Requested allocation size in bytes
  -- * \param flags - Requested properties of allocated memory
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaSetDeviceFlags,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost
  --  

   function cudaHostAlloc
     (pHost : System.Address;
      size : stddef_h.size_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3316
   pragma Import (C, cudaHostAlloc, "cudaHostAlloc");

  --*
  -- * \brief Registers an existing host memory range for use by CUDA
  -- *
  -- * Page-locks the memory range specified by \p ptr and \p size and maps it
  -- * for the device(s) as specified by \p flags. This memory range also is added
  -- * to the same tracking mechanism as ::cudaHostAlloc() to automatically accelerate
  -- * calls to functions such as ::cudaMemcpy(). Since the memory can be accessed 
  -- * directly by the device, it can be read or written with much higher bandwidth 
  -- * than pageable memory that has not been registered.  Page-locking excessive
  -- * amounts of memory may degrade system performance, since it reduces the amount
  -- * of memory available to the system for paging. As a result, this function is
  -- * best used sparingly to register staging areas for data exchange between
  -- * host and device.
  -- *
  -- * The \p flags parameter enables different options to be specified that
  -- * affect the allocation, as follows.
  -- *
  -- * - ::cudaHostRegisterDefault: On a system with unified virtual addressing,
  -- *   the memory will be both mapped and portable.  On a system with no unified
  -- *   virtual addressing, the memory will be neither mapped nor portable.
  -- *
  -- * - ::cudaHostRegisterPortable: The memory returned by this call will be
  -- *   considered as pinned memory by all CUDA contexts, not just the one that
  -- *   performed the allocation.
  -- *
  -- * - ::cudaHostRegisterMapped: Maps the allocation into the CUDA address
  -- *   space. The device pointer to the memory may be obtained by calling
  -- *   ::cudaHostGetDevicePointer().
  -- *
  -- * - ::cudaHostRegisterIoMemory: The passed memory pointer is treated as
  -- *   pointing to some memory-mapped I/O space, e.g. belonging to a
  -- *   third-party PCIe device, and it will marked as non cache-coherent and
  -- *   contiguous.
  -- *
  -- * All of these flags are orthogonal to one another: a developer may page-lock
  -- * memory that is portable or mapped with no restrictions.
  -- *
  -- * The CUDA context must have been created with the ::cudaMapHost flag in
  -- * order for the ::cudaHostRegisterMapped flag to have any effect.
  -- *
  -- * The ::cudaHostRegisterMapped flag may be specified on CUDA contexts for
  -- * devices that do not support mapped pinned memory. The failure is deferred
  -- * to ::cudaHostGetDevicePointer() because the memory may be mapped into
  -- * other CUDA contexts via the ::cudaHostRegisterPortable flag.
  -- *
  -- * For devices that have a non-zero value for the device attribute
  -- * ::cudaDevAttrCanUseHostPointerForRegisteredMem, the memory
  -- * can also be accessed from the device using the host pointer \p ptr.
  -- * The device pointer returned by ::cudaHostGetDevicePointer() may or may not
  -- * match the original host pointer \p ptr and depends on the devices visible to the
  -- * application. If all devices visible to the application have a non-zero value for the
  -- * device attribute, the device pointer returned by ::cudaHostGetDevicePointer()
  -- * will match the original pointer \p ptr. If any device visible to the application
  -- * has a zero value for the device attribute, the device pointer returned by
  -- * ::cudaHostGetDevicePointer() will not match the original host pointer \p ptr,
  -- * but it will be suitable for use on all devices provided Unified Virtual Addressing
  -- * is enabled. In such systems, it is valid to access the memory using either pointer
  -- * on devices that have a non-zero value for the device attribute. Note however that
  -- * such devices should access the memory using only of the two pointers and not both.
  -- *
  -- * The memory page-locked by this function must be unregistered with ::cudaHostUnregister().
  -- *
  -- * \param ptr   - Host pointer to memory to page-lock
  -- * \param size  - Size in bytes of the address range to page-lock in bytes
  -- * \param flags - Flags for allocation request
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorMemoryAllocation,
  -- * ::cudaErrorHostMemoryAlreadyRegistered
  -- * \notefnerr
  -- *
  -- * \sa ::cudaHostUnregister, ::cudaHostGetFlags, ::cudaHostGetDevicePointer
  --  

   function cudaHostRegister
     (ptr : System.Address;
      size : stddef_h.size_t;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3393
   pragma Import (C, cudaHostRegister, "cudaHostRegister");

  --*
  -- * \brief Unregisters a memory range that was registered with cudaHostRegister
  -- *
  -- * Unmaps the memory range whose base address is specified by \p ptr, and makes
  -- * it pageable again.
  -- *
  -- * The base address must be the same one specified to ::cudaHostRegister().
  -- *
  -- * \param ptr - Host pointer to memory to unregister
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaHostUnregister
  --  

   function cudaHostUnregister (ptr : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3412
   pragma Import (C, cudaHostUnregister, "cudaHostUnregister");

  --*
  -- * \brief Passes back device pointer of mapped host memory allocated by
  -- * cudaHostAlloc or registered by cudaHostRegister
  -- *
  -- * Passes back the device pointer corresponding to the mapped, pinned host
  -- * buffer allocated by ::cudaHostAlloc() or registered by ::cudaHostRegister().
  -- *
  -- * ::cudaHostGetDevicePointer() will fail if the ::cudaDeviceMapHost flag was
  -- * not specified before deferred context creation occurred, or if called on a
  -- * device that does not support mapped, pinned memory.
  -- *
  -- * For devices that have a non-zero value for the device attribute
  -- * ::cudaDevAttrCanUseHostPointerForRegisteredMem, the memory
  -- * can also be accessed from the device using the host pointer \p pHost.
  -- * The device pointer returned by ::cudaHostGetDevicePointer() may or may not
  -- * match the original host pointer \p pHost and depends on the devices visible to the
  -- * application. If all devices visible to the application have a non-zero value for the
  -- * device attribute, the device pointer returned by ::cudaHostGetDevicePointer()
  -- * will match the original pointer \p pHost. If any device visible to the application
  -- * has a zero value for the device attribute, the device pointer returned by
  -- * ::cudaHostGetDevicePointer() will not match the original host pointer \p pHost,
  -- * but it will be suitable for use on all devices provided Unified Virtual Addressing
  -- * is enabled. In such systems, it is valid to access the memory using either pointer
  -- * on devices that have a non-zero value for the device attribute. Note however that
  -- * such devices should access the memory using only of the two pointers and not both.
  -- *
  -- * \p flags provides for future releases.  For now, it must be set to 0.
  -- *
  -- * \param pDevice - Returned device pointer for mapped memory
  -- * \param pHost   - Requested host pointer mapping
  -- * \param flags   - Flags for extensions (must be 0 for now)
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaSetDeviceFlags, ::cudaHostAlloc
  --  

   function cudaHostGetDevicePointer
     (pDevice : System.Address;
      pHost : System.Address;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3454
   pragma Import (C, cudaHostGetDevicePointer, "cudaHostGetDevicePointer");

  --*
  -- * \brief Passes back flags used to allocate pinned host memory allocated by
  -- * cudaHostAlloc
  -- *
  -- * ::cudaHostGetFlags() will fail if the input pointer does not
  -- * reside in an address range allocated by ::cudaHostAlloc().
  -- *
  -- * \param pFlags - Returned flags word
  -- * \param pHost - Host pointer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaHostAlloc
  --  

   function cudaHostGetFlags (pFlags : access unsigned; pHost : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3473
   pragma Import (C, cudaHostGetFlags, "cudaHostGetFlags");

  --*
  -- * \brief Allocates logical 1D, 2D, or 3D memory objects on the device
  -- *
  -- * Allocates at least \p width * \p height * \p depth bytes of linear memory
  -- * on the device and returns a ::cudaPitchedPtr in which \p ptr is a pointer
  -- * to the allocated memory. The function may pad the allocation to ensure
  -- * hardware alignment requirements are met. The pitch returned in the \p pitch
  -- * field of \p pitchedDevPtr is the width in bytes of the allocation.
  -- *
  -- * The returned ::cudaPitchedPtr contains additional fields \p xsize and
  -- * \p ysize, the logical width and height of the allocation, which are
  -- * equivalent to the \p width and \p height \p extent parameters provided by
  -- * the programmer during allocation.
  -- *
  -- * For allocations of 2D and 3D objects, it is highly recommended that
  -- * programmers perform allocations using ::cudaMalloc3D() or
  -- * ::cudaMallocPitch(). Due to alignment restrictions in the hardware, this is
  -- * especially true if the application will be performing memory copies
  -- * involving 2D or 3D objects (whether linear memory or CUDA arrays).
  -- *
  -- * \param pitchedDevPtr  - Pointer to allocated pitched device memory
  -- * \param extent         - Requested allocation size (\p width field in bytes)
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMallocPitch, ::cudaFree, ::cudaMemcpy3D, ::cudaMemset3D,
  -- * ::cudaMalloc3DArray, ::cudaMallocArray, ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc, ::make_cudaPitchedPtr, ::make_cudaExtent
  --  

   function cudaMalloc3D (pitchedDevPtr : access driver_types_h.cudaPitchedPtr; extent : driver_types_h.cudaExtent) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3508
   pragma Import (C, cudaMalloc3D, "cudaMalloc3D");

  --*
  -- * \brief Allocate an array on the device
  -- *
  -- * Allocates a CUDA array according to the ::cudaChannelFormatDesc structure
  -- * \p desc and returns a handle to the new CUDA array in \p *array.
  -- *
  -- * The ::cudaChannelFormatDesc is defined as:
  -- * \code
  --    struct cudaChannelFormatDesc {
  --        int x, y, z, w;
  --        enum cudaChannelFormatKind f;
  --    };
  --    \endcode
  -- * where ::cudaChannelFormatKind is one of ::cudaChannelFormatKindSigned,
  -- * ::cudaChannelFormatKindUnsigned, or ::cudaChannelFormatKindFloat.
  -- *
  -- * ::cudaMalloc3DArray() can allocate the following:
  -- *
  -- * - A 1D array is allocated if the height and depth extents are both zero.
  -- * - A 2D array is allocated if only the depth extent is zero.
  -- * - A 3D array is allocated if all three extents are non-zero.
  -- * - A 1D layered CUDA array is allocated if only the height extent is zero and
  -- * the cudaArrayLayered flag is set. Each layer is a 1D array. The number of layers is 
  -- * determined by the depth extent.
  -- * - A 2D layered CUDA array is allocated if all three extents are non-zero and 
  -- * the cudaArrayLayered flag is set. Each layer is a 2D array. The number of layers is 
  -- * determined by the depth extent.
  -- * - A cubemap CUDA array is allocated if all three extents are non-zero and the
  -- * cudaArrayCubemap flag is set. Width must be equal to height, and depth must be six. A cubemap is
  -- * a special type of 2D layered CUDA array, where the six layers represent the six faces of a cube. 
  -- * The order of the six layers in memory is the same as that listed in ::cudaGraphicsCubeFace.
  -- * - A cubemap layered CUDA array is allocated if all three extents are non-zero, and both,
  -- * cudaArrayCubemap and cudaArrayLayered flags are set. Width must be equal to height, and depth must be 
  -- * a multiple of six. A cubemap layered CUDA array is a special type of 2D layered CUDA array that consists 
  -- * of a collection of cubemaps. The first six layers represent the first cubemap, the next six layers form 
  -- * the second cubemap, and so on.
  -- *
  -- *
  -- * The \p flags parameter enables different options to be specified that affect
  -- * the allocation, as follows.
  -- * - ::cudaArrayDefault: This flag's value is defined to be 0 and provides default array allocation
  -- * - ::cudaArrayLayered: Allocates a layered CUDA array, with the depth extent indicating the number of layers
  -- * - ::cudaArrayCubemap: Allocates a cubemap CUDA array. Width must be equal to height, and depth must be six.
  -- *   If the cudaArrayLayered flag is also set, depth must be a multiple of six.
  -- * - ::cudaArraySurfaceLoadStore: Allocates a CUDA array that could be read from or written to using a surface
  -- *   reference.
  -- * - ::cudaArrayTextureGather: This flag indicates that texture gather operations will be performed on the CUDA 
  -- *   array. Texture gather can only be performed on 2D CUDA arrays.
  -- *
  -- * The width, height and depth extents must meet certain size requirements as listed in the following table.
  -- * All values are specified in elements.
  -- *
  -- * Note that 2D CUDA arrays have different size requirements if the ::cudaArrayTextureGather flag is set. In that
  -- * case, the valid range for (width, height, depth) is ((1,maxTexture2DGather[0]), (1,maxTexture2DGather[1]), 0).
  -- *
  -- * \xmlonly
  -- * <table outputclass="xmlonly">
  -- * <tgroup cols="3" colsep="1" rowsep="1">
  -- * <colspec colname="c1" colwidth="1.0*"/>
  -- * <colspec colname="c2" colwidth="3.0*"/>
  -- * <colspec colname="c3" colwidth="3.0*"/>
  -- * <thead>
  -- * <row>
  -- * <entry>CUDA array type</entry>
  -- * <entry>Valid extents that must always be met {(width range in elements),
  -- * (height range), (depth range)}</entry>
  -- * <entry>Valid extents with cudaArraySurfaceLoadStore set {(width range in
  -- * elements), (height range), (depth range)}</entry>
  -- * </row>
  -- * </thead>
  -- * <tbody>
  -- * <row>
  -- * <entry>1D</entry>
  -- * <entry>{ (1,maxTexture1D), 0, 0 }</entry>
  -- * <entry>{ (1,maxSurface1D), 0, 0 }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>2D</entry>
  -- * <entry>{ (1,maxTexture2D[0]), (1,maxTexture2D[1]), 0 }</entry>
  -- * <entry>{ (1,maxSurface2D[0]), (1,maxSurface2D[1]), 0 }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>3D</entry>
  -- * <entry>{ (1,maxTexture3D[0]), (1,maxTexture3D[1]), (1,maxTexture3D[2]) }
  -- * OR { (1,maxTexture3DAlt[0]), (1,maxTexture3DAlt[1]),
  -- * (1,maxTexture3DAlt[2]) }</entry>
  -- * <entry>{ (1,maxSurface3D[0]), (1,maxSurface3D[1]), (1,maxSurface3D[2]) }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>1D Layered</entry>
  -- * <entry>{ (1,maxTexture1DLayered[0]), 0, (1,maxTexture1DLayered[1]) }</entry>
  -- * <entry>{ (1,maxSurface1DLayered[0]), 0, (1,maxSurface1DLayered[1]) }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>2D Layered</entry>
  -- * <entry>{ (1,maxTexture2DLayered[0]), (1,maxTexture2DLayered[1]),
  -- * (1,maxTexture2DLayered[2]) }</entry>
  -- * <entry>{ (1,maxSurface2DLayered[0]), (1,maxSurface2DLayered[1]),
  -- * (1,maxSurface2DLayered[2]) }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>Cubemap</entry>
  -- * <entry>{ (1,maxTextureCubemap), (1,maxTextureCubemap), 6 }</entry>
  -- * <entry>{ (1,maxSurfaceCubemap), (1,maxSurfaceCubemap), 6 }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>Cubemap Layered</entry>
  -- * <entry>{ (1,maxTextureCubemapLayered[0]), (1,maxTextureCubemapLayered[0]),
  -- * (1,maxTextureCubemapLayered[1]) }</entry>
  -- * <entry>{ (1,maxSurfaceCubemapLayered[0]), (1,maxSurfaceCubemapLayered[0]),
  -- * (1,maxSurfaceCubemapLayered[1]) }</entry>
  -- * </row>
  -- * </tbody>
  -- * </tgroup>
  -- * </table>
  -- * \endxmlonly
  -- *
  -- * \param array  - Pointer to allocated array in device memory
  -- * \param desc   - Requested channel format
  -- * \param extent - Requested allocation size (\p width field in elements)
  -- * \param flags  - Flags for extensions
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc3D, ::cudaMalloc, ::cudaMallocPitch, ::cudaFree,
  -- * ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc,
  -- * ::make_cudaExtent
  --  

   function cudaMalloc3DArray
     (c_array : System.Address;
      desc : access constant driver_types_h.cudaChannelFormatDesc;
      extent : driver_types_h.cudaExtent;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3643
   pragma Import (C, cudaMalloc3DArray, "cudaMalloc3DArray");

  --*
  -- * \brief Allocate a mipmapped array on the device
  -- *
  -- * Allocates a CUDA mipmapped array according to the ::cudaChannelFormatDesc structure
  -- * \p desc and returns a handle to the new CUDA mipmapped array in \p *mipmappedArray.
  -- * \p numLevels specifies the number of mipmap levels to be allocated. This value is
  -- * clamped to the range [1, 1 + floor(log2(max(width, height, depth)))].
  -- *
  -- * The ::cudaChannelFormatDesc is defined as:
  -- * \code
  --    struct cudaChannelFormatDesc {
  --        int x, y, z, w;
  --        enum cudaChannelFormatKind f;
  --    };
  --    \endcode
  -- * where ::cudaChannelFormatKind is one of ::cudaChannelFormatKindSigned,
  -- * ::cudaChannelFormatKindUnsigned, or ::cudaChannelFormatKindFloat.
  -- *
  -- * ::cudaMallocMipmappedArray() can allocate the following:
  -- *
  -- * - A 1D mipmapped array is allocated if the height and depth extents are both zero.
  -- * - A 2D mipmapped array is allocated if only the depth extent is zero.
  -- * - A 3D mipmapped array is allocated if all three extents are non-zero.
  -- * - A 1D layered CUDA mipmapped array is allocated if only the height extent is zero and
  -- * the cudaArrayLayered flag is set. Each layer is a 1D mipmapped array. The number of layers is 
  -- * determined by the depth extent.
  -- * - A 2D layered CUDA mipmapped array is allocated if all three extents are non-zero and 
  -- * the cudaArrayLayered flag is set. Each layer is a 2D mipmapped array. The number of layers is 
  -- * determined by the depth extent.
  -- * - A cubemap CUDA mipmapped array is allocated if all three extents are non-zero and the
  -- * cudaArrayCubemap flag is set. Width must be equal to height, and depth must be six.
  -- * The order of the six layers in memory is the same as that listed in ::cudaGraphicsCubeFace.
  -- * - A cubemap layered CUDA mipmapped array is allocated if all three extents are non-zero, and both,
  -- * cudaArrayCubemap and cudaArrayLayered flags are set. Width must be equal to height, and depth must be 
  -- * a multiple of six. A cubemap layered CUDA mipmapped array is a special type of 2D layered CUDA mipmapped
  -- * array that consists of a collection of cubemap mipmapped arrays. The first six layers represent the 
  -- * first cubemap mipmapped array, the next six layers form the second cubemap mipmapped array, and so on.
  -- *
  -- *
  -- * The \p flags parameter enables different options to be specified that affect
  -- * the allocation, as follows.
  -- * - ::cudaArrayDefault: This flag's value is defined to be 0 and provides default mipmapped array allocation
  -- * - ::cudaArrayLayered: Allocates a layered CUDA mipmapped array, with the depth extent indicating the number of layers
  -- * - ::cudaArrayCubemap: Allocates a cubemap CUDA mipmapped array. Width must be equal to height, and depth must be six.
  -- *   If the cudaArrayLayered flag is also set, depth must be a multiple of six.
  -- * - ::cudaArraySurfaceLoadStore: This flag indicates that individual mipmap levels of the CUDA mipmapped array 
  -- *   will be read from or written to using a surface reference.
  -- * - ::cudaArrayTextureGather: This flag indicates that texture gather operations will be performed on the CUDA 
  -- *   array. Texture gather can only be performed on 2D CUDA mipmapped arrays, and the gather operations are
  -- *   performed only on the most detailed mipmap level.
  -- *
  -- * The width, height and depth extents must meet certain size requirements as listed in the following table.
  -- * All values are specified in elements.
  -- *
  -- * \xmlonly
  -- * <table outputclass="xmlonly">
  -- * <tgroup cols="2" colsep="1" rowsep="1">
  -- * <colspec colname="c1" colwidth="1.0*"/>
  -- * <colspec colname="c2" colwidth="3.0*"/>
  -- * <thead>
  -- * <row>
  -- * <entry>CUDA array type</entry>
  -- * <entry>Valid extents {(width range in elements), (height range), (depth
  -- * range)}</entry>
  -- * </row>
  -- * </thead>
  -- * <tbody>
  -- * <row>
  -- * <entry>1D</entry>
  -- * <entry>{ (1,maxTexture1DMipmap), 0, 0 }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>2D</entry>
  -- * <entry>{ (1,maxTexture2DMipmap[0]), (1,maxTexture2DMipmap[1]), 0 }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>3D</entry>
  -- * <entry>{ (1,maxTexture3D[0]), (1,maxTexture3D[1]), (1,maxTexture3D[2]) }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>1D Layered</entry>
  -- * <entry>{ (1,maxTexture1DLayered[0]), 0, (1,maxTexture1DLayered[1]) }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>2D Layered</entry>
  -- * <entry>{ (1,maxTexture2DLayered[0]), (1,maxTexture2DLayered[1]),
  -- * (1,maxTexture2DLayered[2]) }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>Cubemap</entry>
  -- * <entry>{ (1,maxTextureCubemap), (1,maxTextureCubemap), 6 }</entry>
  -- * </row>
  -- * <row>
  -- * <entry>Cubemap Layered</entry>
  -- * <entry>{ (1,maxTextureCubemapLayered[0]), (1,maxTextureCubemapLayered[0]),
  -- * (1,maxTextureCubemapLayered[1]) }</entry>
  -- * </row>
  -- * </tbody>
  -- * </tgroup>
  -- * </table>
  -- * \endxmlonly
  -- *
  -- * \param mipmappedArray  - Pointer to allocated mipmapped array in device memory
  -- * \param desc            - Requested channel format
  -- * \param extent          - Requested allocation size (\p width field in elements)
  -- * \param numLevels       - Number of mipmap levels to allocate
  -- * \param flags           - Flags for extensions
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorMemoryAllocation
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc3D, ::cudaMalloc, ::cudaMallocPitch, ::cudaFree,
  -- * ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc,
  -- * ::make_cudaExtent
  --  

   function cudaMallocMipmappedArray
     (mipmappedArray : System.Address;
      desc : access constant driver_types_h.cudaChannelFormatDesc;
      extent : driver_types_h.cudaExtent;
      numLevels : unsigned;
      flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3764
   pragma Import (C, cudaMallocMipmappedArray, "cudaMallocMipmappedArray");

  --*
  -- * \brief Gets a mipmap level of a CUDA mipmapped array
  -- *
  -- * Returns in \p *levelArray a CUDA array that represents a single mipmap level
  -- * of the CUDA mipmapped array \p mipmappedArray.
  -- *
  -- * If \p level is greater than the maximum number of levels in this mipmapped array,
  -- * ::cudaErrorInvalidValue is returned.
  -- *
  -- * \param levelArray     - Returned mipmap level CUDA array
  -- * \param mipmappedArray - CUDA mipmapped array
  -- * \param level          - Mipmap level
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMalloc3D, ::cudaMalloc, ::cudaMallocPitch, ::cudaFree,
  -- * ::cudaFreeArray,
  -- * \ref ::cudaMallocHost(void**, size_t) "cudaMallocHost (C API)",
  -- * ::cudaFreeHost, ::cudaHostAlloc,
  -- * ::make_cudaExtent
  --  

   function cudaGetMipmappedArrayLevel
     (levelArray : System.Address;
      mipmappedArray : driver_types_h.cudaMipmappedArray_const_t;
      level : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3790
   pragma Import (C, cudaGetMipmappedArrayLevel, "cudaGetMipmappedArrayLevel");

  --*
  -- * \brief Copies data between 3D objects
  -- *
  --\code
  --struct cudaExtent {
  --  size_t width;
  --  size_t height;
  --  size_t depth;
  --};
  --struct cudaExtent make_cudaExtent(size_t w, size_t h, size_t d);
  --struct cudaPos {
  --  size_t x;
  --  size_t y;
  --  size_t z;
  --};
  --struct cudaPos make_cudaPos(size_t x, size_t y, size_t z);
  --struct cudaMemcpy3DParms {
  --  cudaArray_t           srcArray;
  --  struct cudaPos        srcPos;
  --  struct cudaPitchedPtr srcPtr;
  --  cudaArray_t           dstArray;
  --  struct cudaPos        dstPos;
  --  struct cudaPitchedPtr dstPtr;
  --  struct cudaExtent     extent;
  --  enum cudaMemcpyKind   kind;
  --};
  --\endcode
  -- *
  -- * ::cudaMemcpy3D() copies data betwen two 3D objects. The source and
  -- * destination objects may be in either host memory, device memory, or a CUDA
  -- * array. The source, destination, extent, and kind of copy performed is
  -- * specified by the ::cudaMemcpy3DParms struct which should be initialized to
  -- * zero before use:
  --\code
  --cudaMemcpy3DParms myParms = {0};
  --\endcode
  -- *
  -- * The struct passed to ::cudaMemcpy3D() must specify one of \p srcArray or
  -- * \p srcPtr and one of \p dstArray or \p dstPtr. Passing more than one
  -- * non-zero source or destination will cause ::cudaMemcpy3D() to return an
  -- * error.
  -- *
  -- * The \p srcPos and \p dstPos fields are optional offsets into the source and
  -- * destination objects and are defined in units of each object's elements. The
  -- * element for a host or device pointer is assumed to be <b>unsigned char</b>.
  -- * For CUDA arrays, positions must be in the range [0, 2048) for any
  -- * dimension.
  -- *
  -- * The \p extent field defines the dimensions of the transferred area in
  -- * elements. If a CUDA array is participating in the copy, the extent is
  -- * defined in terms of that array's elements. If no CUDA array is
  -- * participating in the copy then the extents are defined in elements of
  -- * <b>unsigned char</b>.
  -- *
  -- * The \p kind field defines the direction of the copy. It must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * If the source and destination are both arrays, ::cudaMemcpy3D() will return
  -- * an error if they do not have the same element size.
  -- *
  -- * The source and destination object may not overlap. If overlapping source
  -- * and destination objects are specified, undefined behavior will result.
  -- *
  -- * The source object must lie entirely within the region defined by \p srcPos
  -- * and \p extent. The destination object must lie entirely within the region
  -- * defined by \p dstPos and \p extent.
  -- *
  -- * ::cudaMemcpy3D() returns an error if the pitch of \p srcPtr or \p dstPtr
  -- * exceeds the maximum allowed. The pitch of a ::cudaPitchedPtr allocated
  -- * with ::cudaMalloc3D() will always be valid.
  -- *
  -- * \param p - 3D memory copy parameters
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMalloc3D, ::cudaMalloc3DArray, ::cudaMemset3D, ::cudaMemcpy3DAsync,
  -- * ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync,
  -- * ::make_cudaExtent, ::make_cudaPos
  --  

   function cudaMemcpy3D (p : access constant driver_types_h.cudaMemcpy3DParms) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3890
   pragma Import (C, cudaMemcpy3D, "cudaMemcpy3D");

  --*
  -- * \brief Copies memory between devices
  -- *
  -- * Perform a 3D memory copy according to the parameters specified in
  -- * \p p.  See the definition of the ::cudaMemcpy3DPeerParms structure
  -- * for documentation of its parameters.
  -- *
  -- * Note that this function is synchronous with respect to the host only if
  -- * the source or destination of the transfer is host memory.  Note also 
  -- * that this copy is serialized with respect to all pending and future 
  -- * asynchronous work in to the current device, the copy's source device,
  -- * and the copy's destination device (use ::cudaMemcpy3DPeerAsync to avoid 
  -- * this synchronization).
  -- *
  -- * \param p - Parameters for the memory copy
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpyPeer, ::cudaMemcpyAsync, ::cudaMemcpyPeerAsync,
  -- * ::cudaMemcpy3DPeerAsync
  --  

   function cudaMemcpy3DPeer (p : access constant driver_types_h.cudaMemcpy3DPeerParms) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:3918
   pragma Import (C, cudaMemcpy3DPeer, "cudaMemcpy3DPeer");

  --*
  -- * \brief Copies data between 3D objects
  -- *
  --\code
  --struct cudaExtent {
  --  size_t width;
  --  size_t height;
  --  size_t depth;
  --};
  --struct cudaExtent make_cudaExtent(size_t w, size_t h, size_t d);
  --struct cudaPos {
  --  size_t x;
  --  size_t y;
  --  size_t z;
  --};
  --struct cudaPos make_cudaPos(size_t x, size_t y, size_t z);
  --struct cudaMemcpy3DParms {
  --  cudaArray_t           srcArray;
  --  struct cudaPos        srcPos;
  --  struct cudaPitchedPtr srcPtr;
  --  cudaArray_t           dstArray;
  --  struct cudaPos        dstPos;
  --  struct cudaPitchedPtr dstPtr;
  --  struct cudaExtent     extent;
  --  enum cudaMemcpyKind   kind;
  --};
  --\endcode
  -- *
  -- * ::cudaMemcpy3DAsync() copies data betwen two 3D objects. The source and
  -- * destination objects may be in either host memory, device memory, or a CUDA
  -- * array. The source, destination, extent, and kind of copy performed is
  -- * specified by the ::cudaMemcpy3DParms struct which should be initialized to
  -- * zero before use:
  --\code
  --cudaMemcpy3DParms myParms = {0};
  --\endcode
  -- *
  -- * The struct passed to ::cudaMemcpy3DAsync() must specify one of \p srcArray
  -- * or \p srcPtr and one of \p dstArray or \p dstPtr. Passing more than one
  -- * non-zero source or destination will cause ::cudaMemcpy3DAsync() to return an
  -- * error.
  -- *
  -- * The \p srcPos and \p dstPos fields are optional offsets into the source and
  -- * destination objects and are defined in units of each object's elements. The
  -- * element for a host or device pointer is assumed to be <b>unsigned char</b>.
  -- * For CUDA arrays, positions must be in the range [0, 2048) for any
  -- * dimension.
  -- *
  -- * The \p extent field defines the dimensions of the transferred area in
  -- * elements. If a CUDA array is participating in the copy, the extent is
  -- * defined in terms of that array's elements. If no CUDA array is
  -- * participating in the copy then the extents are defined in elements of
  -- * <b>unsigned char</b>.
  -- *
  -- * The \p kind field defines the direction of the copy. It must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * If the source and destination are both arrays, ::cudaMemcpy3DAsync() will
  -- * return an error if they do not have the same element size.
  -- *
  -- * The source and destination object may not overlap. If overlapping source
  -- * and destination objects are specified, undefined behavior will result.
  -- *
  -- * The source object must lie entirely within the region defined by \p srcPos
  -- * and \p extent. The destination object must lie entirely within the region
  -- * defined by \p dstPos and \p extent.
  -- *
  -- * ::cudaMemcpy3DAsync() returns an error if the pitch of \p srcPtr or
  -- * \p dstPtr exceeds the maximum allowed. The pitch of a
  -- * ::cudaPitchedPtr allocated with ::cudaMalloc3D() will always be valid.
  -- *
  -- * ::cudaMemcpy3DAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument. If
  -- * \p kind is ::cudaMemcpyHostToDevice or ::cudaMemcpyDeviceToHost and \p stream
  -- * is non-zero, the copy may overlap with operations in other streams.
  -- *
  -- * The device version of this function only handles device to device copies and
  -- * cannot be given local or shared pointers.
  -- *
  -- * \param p      - 3D memory copy parameters
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMalloc3D, ::cudaMalloc3DArray, ::cudaMemset3D, ::cudaMemcpy3D,
  -- * ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync,
  -- * ::make_cudaExtent, ::make_cudaPos
  --  

   function cudaMemcpy3DAsync (p : access constant driver_types_h.cudaMemcpy3DParms; stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4029
   pragma Import (C, cudaMemcpy3DAsync, "cudaMemcpy3DAsync");

  --*
  -- * \brief Copies memory between devices asynchronously.
  -- *
  -- * Perform a 3D memory copy according to the parameters specified in
  -- * \p p.  See the definition of the ::cudaMemcpy3DPeerParms structure
  -- * for documentation of its parameters.
  -- *
  -- * \param p      - Parameters for the memory copy
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpyPeer, ::cudaMemcpyAsync, ::cudaMemcpyPeerAsync,
  -- * ::cudaMemcpy3DPeerAsync
  --  

   function cudaMemcpy3DPeerAsync (p : access constant driver_types_h.cudaMemcpy3DPeerParms; stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4052
   pragma Import (C, cudaMemcpy3DPeerAsync, "cudaMemcpy3DPeerAsync");

  --*
  -- * \brief Gets free and total device memory
  -- *
  -- * Returns in \p *free and \p *total respectively, the free and total amount of
  -- * memory available for allocation by the device in bytes.
  -- *
  -- * \param free  - Returned free memory in bytes
  -- * \param total - Returned total memory in bytes
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInitializationError,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorLaunchFailure
  -- * \notefnerr
  -- *
  --  

   function cudaMemGetInfo (free : access stddef_h.size_t; total : access stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4071
   pragma Import (C, cudaMemGetInfo, "cudaMemGetInfo");

  --*
  -- * \brief Gets info about the specified cudaArray
  -- * 
  -- * Returns in \p *desc, \p *extent and \p *flags respectively, the type, shape 
  -- * and flags of \p array.
  -- *
  -- * Any of \p *desc, \p *extent and \p *flags may be specified as NULL.
  -- *
  -- * \param desc   - Returned array type
  -- * \param extent - Returned array shape. 2D arrays will have depth of zero
  -- * \param flags  - Returned array flags
  -- * \param array  - The ::cudaArray to get info for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  --  

   function cudaArrayGetInfo
     (desc : access driver_types_h.cudaChannelFormatDesc;
      extent : access driver_types_h.cudaExtent;
      flags : access unsigned;
      c_array : driver_types_h.cudaArray_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4092
   pragma Import (C, cudaArrayGetInfo, "cudaArrayGetInfo");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p src to the
  -- * memory area pointed to by \p dst, where \p kind specifies the direction
  -- * of the copy, and must be one of ::cudaMemcpyHostToHost,
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing. Calling
  -- * ::cudaMemcpy() with dst and src pointers that do not match the direction of
  -- * the copy results in an undefined behavior.
  -- *
  -- * \param dst   - Destination memory address
  -- * \param src   - Source memory address
  -- * \param count - Size in bytes to copy
  -- * \param kind  - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- *
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy
     (dst : System.Address;
      src : System.Address;
      count : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4130
   pragma Import (C, cudaMemcpy, "cudaMemcpy");

  --*
  -- * \brief Copies memory between two devices
  -- *
  -- * Copies memory from one device to memory on another device.  \p dst is the 
  -- * base device pointer of the destination memory and \p dstDevice is the 
  -- * destination device.  \p src is the base device pointer of the source memory 
  -- * and \p srcDevice is the source device.  \p count specifies the number of bytes 
  -- * to copy.
  -- *
  -- * Note that this function is asynchronous with respect to the host, but 
  -- * serialized with respect all pending and future asynchronous work in to the 
  -- * current device, \p srcDevice, and \p dstDevice (use ::cudaMemcpyPeerAsync 
  -- * to avoid this synchronization).
  -- *
  -- * \param dst       - Destination device pointer
  -- * \param dstDevice - Destination device
  -- * \param src       - Source device pointer
  -- * \param srcDevice - Source device
  -- * \param count     - Size of memory copy in bytes
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpyAsync, ::cudaMemcpyPeerAsync,
  -- * ::cudaMemcpy3DPeerAsync
  --  

   function cudaMemcpyPeer
     (dst : System.Address;
      dstDevice : int;
      src : System.Address;
      srcDevice : int;
      count : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4162
   pragma Import (C, cudaMemcpyPeer, "cudaMemcpyPeer");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p src to the
  -- * CUDA array \p dst starting at the upper left corner
  -- * (\p wOffset, \p hOffset), where \p kind specifies the direction
  -- * of the copy, and must be one of ::cudaMemcpyHostToHost,
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param wOffset - Destination starting X offset
  -- * \param hOffset - Destination starting Y offset
  -- * \param src     - Source memory address
  -- * \param count   - Size in bytes to copy
  -- * \param kind    - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyToArray
     (dst : driver_types_h.cudaArray_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      src : System.Address;
      count : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4200
   pragma Import (C, cudaMemcpyToArray, "cudaMemcpyToArray");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies \p count bytes from the CUDA array \p src starting at the upper
  -- * left corner (\p wOffset, hOffset) to the memory area pointed to by \p dst,
  -- * where \p kind specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param src     - Source memory address
  -- * \param wOffset - Source starting X offset
  -- * \param hOffset - Source starting Y offset
  -- * \param count   - Size in bytes to copy
  -- * \param kind    - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyFromArray
     (dst : System.Address;
      src : driver_types_h.cudaArray_const_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      count : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4237
   pragma Import (C, cudaMemcpyFromArray, "cudaMemcpyFromArray");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies \p count bytes from the CUDA array \p src starting at the upper
  -- * left corner (\p wOffsetSrc, \p hOffsetSrc) to the CUDA array \p dst
  -- * starting at the upper left corner (\p wOffsetDst, \p hOffsetDst) where
  -- * \p kind specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * \param dst        - Destination memory address
  -- * \param wOffsetDst - Destination starting X offset
  -- * \param hOffsetDst - Destination starting Y offset
  -- * \param src        - Source memory address
  -- * \param wOffsetSrc - Source starting X offset
  -- * \param hOffsetSrc - Source starting Y offset
  -- * \param count      - Size in bytes to copy
  -- * \param kind       - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyArrayToArray
     (dst : driver_types_h.cudaArray_t;
      wOffsetDst : stddef_h.size_t;
      hOffsetDst : stddef_h.size_t;
      src : driver_types_h.cudaArray_const_t;
      wOffsetSrc : stddef_h.size_t;
      hOffsetSrc : stddef_h.size_t;
      count : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4275
   pragma Import (C, cudaMemcpyArrayToArray, "cudaMemcpyArrayToArray");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies a matrix (\p height rows of \p width bytes each) from the memory
  -- * area pointed to by \p src to the memory area pointed to by \p dst, where
  -- * \p kind specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing. \p dpitch and
  -- * \p spitch are the widths in memory in bytes of the 2D arrays pointed to by
  -- * \p dst and \p src, including any padding added to the end of each row. The
  -- * memory areas may not overlap. \p width must not exceed either \p dpitch or
  -- * \p spitch. Calling ::cudaMemcpy2D() with \p dst and \p src pointers that do
  -- * not match the direction of the copy results in an undefined behavior.
  -- * ::cudaMemcpy2D() returns an error if \p dpitch or \p spitch exceeds
  -- * the maximum allowed.
  -- *
  -- * \param dst    - Destination memory address
  -- * \param dpitch - Pitch of destination memory
  -- * \param src    - Source memory address
  -- * \param spitch - Pitch of source memory
  -- * \param width  - Width of matrix transfer (columns in bytes)
  -- * \param height - Height of matrix transfer (rows)
  -- * \param kind   - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy2D
     (dst : System.Address;
      dpitch : stddef_h.size_t;
      src : System.Address;
      spitch : stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4320
   pragma Import (C, cudaMemcpy2D, "cudaMemcpy2D");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies a matrix (\p height rows of \p width bytes each) from the memory
  -- * area pointed to by \p src to the CUDA array \p dst starting at the
  -- * upper left corner (\p wOffset, \p hOffset) where \p kind specifies the
  -- * direction of the copy, and must be one of ::cudaMemcpyHostToHost,
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- * \p spitch is the width in memory in bytes of the 2D array pointed to by
  -- * \p src, including any padding added to the end of each row. \p wOffset +
  -- * \p width must not exceed the width of the CUDA array \p dst. \p width must
  -- * not exceed \p spitch. ::cudaMemcpy2DToArray() returns an error if \p spitch
  -- * exceeds the maximum allowed.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param wOffset - Destination starting X offset
  -- * \param hOffset - Destination starting Y offset
  -- * \param src     - Source memory address
  -- * \param spitch  - Pitch of source memory
  -- * \param width   - Width of matrix transfer (columns in bytes)
  -- * \param height  - Height of matrix transfer (rows)
  -- * \param kind    - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy2DToArray
     (dst : driver_types_h.cudaArray_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      src : System.Address;
      spitch : stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4366
   pragma Import (C, cudaMemcpy2DToArray, "cudaMemcpy2DToArray");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies a matrix (\p height rows of \p width bytes each) from the CUDA
  -- * array \p srcArray starting at the upper left corner
  -- * (\p wOffset, \p hOffset) to the memory area pointed to by \p dst, where
  -- * \p kind specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing. \p dpitch is the
  -- * width in memory in bytes of the 2D array pointed to by \p dst, including any
  -- * padding added to the end of each row. \p wOffset + \p width must not exceed
  -- * the width of the CUDA array \p src. \p width must not exceed \p dpitch.
  -- * ::cudaMemcpy2DFromArray() returns an error if \p dpitch exceeds the maximum
  -- * allowed.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param dpitch  - Pitch of destination memory
  -- * \param src     - Source memory address
  -- * \param wOffset - Source starting X offset
  -- * \param hOffset - Source starting Y offset
  -- * \param width   - Width of matrix transfer (columns in bytes)
  -- * \param height  - Height of matrix transfer (rows)
  -- * \param kind    - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy2DFromArray
     (dst : System.Address;
      dpitch : stddef_h.size_t;
      src : driver_types_h.cudaArray_const_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4412
   pragma Import (C, cudaMemcpy2DFromArray, "cudaMemcpy2DFromArray");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies a matrix (\p height rows of \p width bytes each) from the CUDA
  -- * array \p srcArray starting at the upper left corner
  -- * (\p wOffsetSrc, \p hOffsetSrc) to the CUDA array \p dst starting at
  -- * the upper left corner (\p wOffsetDst, \p hOffsetDst), where \p kind
  -- * specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- * \p wOffsetDst + \p width must not exceed the width of the CUDA array \p dst.
  -- * \p wOffsetSrc + \p width must not exceed the width of the CUDA array \p src.
  -- *
  -- * \param dst        - Destination memory address
  -- * \param wOffsetDst - Destination starting X offset
  -- * \param hOffsetDst - Destination starting Y offset
  -- * \param src        - Source memory address
  -- * \param wOffsetSrc - Source starting X offset
  -- * \param hOffsetSrc - Source starting Y offset
  -- * \param width      - Width of matrix transfer (columns in bytes)
  -- * \param height     - Height of matrix transfer (rows)
  -- * \param kind       - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy2DArrayToArray
     (dst : driver_types_h.cudaArray_t;
      wOffsetDst : stddef_h.size_t;
      hOffsetDst : stddef_h.size_t;
      src : driver_types_h.cudaArray_const_t;
      wOffsetSrc : stddef_h.size_t;
      hOffsetSrc : stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4455
   pragma Import (C, cudaMemcpy2DArrayToArray, "cudaMemcpy2DArrayToArray");

  --*
  -- * \brief Copies data to the given symbol on the device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p src
  -- * to the memory area pointed to by \p offset bytes from the start of symbol
  -- * \p symbol. The memory areas may not overlap. \p symbol is a variable that
  -- * resides in global or constant memory space. \p kind can be either
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault.
  -- * Passing ::cudaMemcpyDefault is recommended, in which case the type of
  -- * transfer is inferred from the pointer values. However, ::cudaMemcpyDefault
  -- * is only allowed on systems that support unified virtual addressing.
  -- *
  -- * \param symbol - Device symbol address
  -- * \param src    - Source memory address
  -- * \param count  - Size in bytes to copy
  -- * \param offset - Offset from start of symbol in bytes
  -- * \param kind   - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidSymbol,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- * \note_string_api_deprecation
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyToSymbol
     (symbol : System.Address;
      src : System.Address;
      count : stddef_h.size_t;
      offset : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4493
   pragma Import (C, cudaMemcpyToSymbol, "cudaMemcpyToSymbol");

  --*
  -- * \brief Copies data from the given symbol on the device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p offset bytes
  -- * from the start of symbol \p symbol to the memory area pointed to by \p dst.
  -- * The memory areas may not overlap. \p symbol is a variable that
  -- * resides in global or constant memory space. \p kind can be either
  -- * ::cudaMemcpyDeviceToHost, ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault.
  -- * Passing ::cudaMemcpyDefault is recommended, in which case the type of
  -- * transfer is inferred from the pointer values. However, ::cudaMemcpyDefault
  -- * is only allowed on systems that support unified virtual addressing.
  -- *
  -- * \param dst    - Destination memory address
  -- * \param symbol - Device symbol address
  -- * \param count  - Size in bytes to copy
  -- * \param offset - Offset from start of symbol in bytes
  -- * \param kind   - Type of transfer
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidSymbol,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_sync
  -- * \note_string_api_deprecation
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyFromSymbol
     (dst : System.Address;
      symbol : System.Address;
      count : stddef_h.size_t;
      offset : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4531
   pragma Import (C, cudaMemcpyFromSymbol, "cudaMemcpyFromSymbol");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p src to the
  -- * memory area pointed to by \p dst, where \p kind specifies the
  -- * direction of the copy, and must be one of ::cudaMemcpyHostToHost,
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- * 
  -- * The memory areas may not overlap. Calling ::cudaMemcpyAsync() with \p dst and
  -- * \p src pointers that do not match the direction of the copy results in an
  -- * undefined behavior.
  -- *
  -- * ::cudaMemcpyAsync() is asynchronous with respect to the host, so the call
  -- * may return before the copy is complete. The copy can optionally be
  -- * associated to a stream by passing a non-zero \p stream argument. If \p kind
  -- * is ::cudaMemcpyHostToDevice or ::cudaMemcpyDeviceToHost and the \p stream is
  -- * non-zero, the copy may overlap with operations in other streams.
  -- *
  -- * The device version of this function only handles device to device copies and
  -- * cannot be given local or shared pointers.
  -- *
  -- * \param dst    - Destination memory address
  -- * \param src    - Source memory address
  -- * \param count  - Size in bytes to copy
  -- * \param kind   - Type of transfer
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyAsync
     (dst : System.Address;
      src : System.Address;
      count : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4582
   pragma Import (C, cudaMemcpyAsync, "cudaMemcpyAsync");

  --*
  -- * \brief Copies memory between two devices asynchronously.
  -- *
  -- * Copies memory from one device to memory on another device.  \p dst is the 
  -- * base device pointer of the destination memory and \p dstDevice is the 
  -- * destination device.  \p src is the base device pointer of the source memory 
  -- * and \p srcDevice is the source device.  \p count specifies the number of bytes 
  -- * to copy.
  -- *
  -- * Note that this function is asynchronous with respect to the host and all work
  -- * on other devices.
  -- *
  -- * \param dst       - Destination device pointer
  -- * \param dstDevice - Destination device
  -- * \param src       - Source device pointer
  -- * \param srcDevice - Source device
  -- * \param count     - Size of memory copy in bytes
  -- * \param stream    - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpyPeer, ::cudaMemcpyAsync,
  -- * ::cudaMemcpy3DPeerAsync
  --  

   function cudaMemcpyPeerAsync
     (dst : System.Address;
      dstDevice : int;
      src : System.Address;
      srcDevice : int;
      count : stddef_h.size_t;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4614
   pragma Import (C, cudaMemcpyPeerAsync, "cudaMemcpyPeerAsync");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p src to the
  -- * CUDA array \p dst starting at the upper left corner
  -- * (\p wOffset, \p hOffset), where \p kind specifies the
  -- * direction of the copy, and must be one of ::cudaMemcpyHostToHost,
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * ::cudaMemcpyToArrayAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument. If \p
  -- * kind is ::cudaMemcpyHostToDevice or ::cudaMemcpyDeviceToHost and \p stream
  -- * is non-zero, the copy may overlap with operations in other streams.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param wOffset - Destination starting X offset
  -- * \param hOffset - Destination starting Y offset
  -- * \param src     - Source memory address
  -- * \param count   - Size in bytes to copy
  -- * \param kind    - Type of transfer
  -- * \param stream  - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyToArrayAsync
     (dst : driver_types_h.cudaArray_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      src : System.Address;
      count : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4660
   pragma Import (C, cudaMemcpyToArrayAsync, "cudaMemcpyToArrayAsync");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies \p count bytes from the CUDA array \p src starting at the upper
  -- * left corner (\p wOffset, hOffset) to the memory area pointed to by \p dst,
  -- * where \p kind specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * ::cudaMemcpyFromArrayAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument. If \p
  -- * kind is ::cudaMemcpyHostToDevice or ::cudaMemcpyDeviceToHost and \p stream
  -- * is non-zero, the copy may overlap with operations in other streams.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param src     - Source memory address
  -- * \param wOffset - Source starting X offset
  -- * \param hOffset - Source starting Y offset
  -- * \param count   - Size in bytes to copy
  -- * \param kind    - Type of transfer
  -- * \param stream  - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyFromArrayAsync
     (dst : System.Address;
      src : driver_types_h.cudaArray_const_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      count : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4705
   pragma Import (C, cudaMemcpyFromArrayAsync, "cudaMemcpyFromArrayAsync");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies a matrix (\p height rows of \p width bytes each) from the memory
  -- * area pointed to by \p src to the memory area pointed to by \p dst, where
  -- * \p kind specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- * \p dpitch and \p spitch are the widths in memory in bytes of the 2D arrays
  -- * pointed to by \p dst and \p src, including any padding added to the end of
  -- * each row. The memory areas may not overlap. \p width must not exceed either
  -- * \p dpitch or \p spitch.
  -- *
  -- * Calling ::cudaMemcpy2DAsync() with \p dst and \p src pointers that do not
  -- * match the direction of the copy results in an undefined behavior.
  -- * ::cudaMemcpy2DAsync() returns an error if \p dpitch or \p spitch is greater
  -- * than the maximum allowed.
  -- *
  -- * ::cudaMemcpy2DAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument. If
  -- * \p kind is ::cudaMemcpyHostToDevice or ::cudaMemcpyDeviceToHost and
  -- * \p stream is non-zero, the copy may overlap with operations in other
  -- * streams.
  -- *
  -- * The device version of this function only handles device to device copies and
  -- * cannot be given local or shared pointers.
  -- *
  -- * \param dst    - Destination memory address
  -- * \param dpitch - Pitch of destination memory
  -- * \param src    - Source memory address
  -- * \param spitch - Pitch of source memory
  -- * \param width  - Width of matrix transfer (columns in bytes)
  -- * \param height - Height of matrix transfer (rows)
  -- * \param kind   - Type of transfer
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy2DAsync
     (dst : System.Address;
      dpitch : stddef_h.size_t;
      src : System.Address;
      spitch : stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4765
   pragma Import (C, cudaMemcpy2DAsync, "cudaMemcpy2DAsync");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies a matrix (\p height rows of \p width bytes each) from the memory
  -- * area pointed to by \p src to the CUDA array \p dst starting at the
  -- * upper left corner (\p wOffset, \p hOffset) where \p kind specifies the
  -- * direction of the copy, and must be one of ::cudaMemcpyHostToHost,
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- * \p spitch is the width in memory in bytes of the 2D array pointed to by
  -- * \p src, including any padding added to the end of each row. \p wOffset +
  -- * \p width must not exceed the width of the CUDA array \p dst. \p width must
  -- * not exceed \p spitch. ::cudaMemcpy2DToArrayAsync() returns an error if
  -- * \p spitch exceeds the maximum allowed.
  -- *
  -- * ::cudaMemcpy2DToArrayAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument. If
  -- * \p kind is ::cudaMemcpyHostToDevice or ::cudaMemcpyDeviceToHost and
  -- * \p stream is non-zero, the copy may overlap with operations in other
  -- * streams.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param wOffset - Destination starting X offset
  -- * \param hOffset - Destination starting Y offset
  -- * \param src     - Source memory address
  -- * \param spitch  - Pitch of source memory
  -- * \param width   - Width of matrix transfer (columns in bytes)
  -- * \param height  - Height of matrix transfer (rows)
  -- * \param kind    - Type of transfer
  -- * \param stream  - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy2DToArrayAsync
     (dst : driver_types_h.cudaArray_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      src : System.Address;
      spitch : stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4820
   pragma Import (C, cudaMemcpy2DToArrayAsync, "cudaMemcpy2DToArrayAsync");

  --*
  -- * \brief Copies data between host and device
  -- *
  -- * Copies a matrix (\p height rows of \p width bytes each) from the CUDA
  -- * array \p srcArray starting at the upper left corner
  -- * (\p wOffset, \p hOffset) to the memory area pointed to by \p dst, where
  -- * \p kind specifies the direction of the copy, and must be one of
  -- * ::cudaMemcpyHostToHost, ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToHost,
  -- * ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault. Passing
  -- * ::cudaMemcpyDefault is recommended, in which case the type of transfer is
  -- * inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- * \p dpitch is the width in memory in bytes of the 2D
  -- * array pointed to by \p dst, including any padding added to the end of each
  -- * row. \p wOffset + \p width must not exceed the width of the CUDA array
  -- * \p src. \p width must not exceed \p dpitch. ::cudaMemcpy2DFromArrayAsync()
  -- * returns an error if \p dpitch exceeds the maximum allowed.
  -- *
  -- * ::cudaMemcpy2DFromArrayAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally be
  -- * associated to a stream by passing a non-zero \p stream argument. If \p kind
  -- * is ::cudaMemcpyHostToDevice or ::cudaMemcpyDeviceToHost and \p stream is
  -- * non-zero, the copy may overlap with operations in other streams.
  -- *
  -- * \param dst     - Destination memory address
  -- * \param dpitch  - Pitch of destination memory
  -- * \param src     - Source memory address
  -- * \param wOffset - Source starting X offset
  -- * \param hOffset - Source starting Y offset
  -- * \param width   - Width of matrix transfer (columns in bytes)
  -- * \param height  - Height of matrix transfer (rows)
  -- * \param kind    - Type of transfer
  -- * \param stream  - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidPitchValue,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync, ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpy2DFromArrayAsync
     (dst : System.Address;
      dpitch : stddef_h.size_t;
      src : driver_types_h.cudaArray_const_t;
      wOffset : stddef_h.size_t;
      hOffset : stddef_h.size_t;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4874
   pragma Import (C, cudaMemcpy2DFromArrayAsync, "cudaMemcpy2DFromArrayAsync");

  --*
  -- * \brief Copies data to the given symbol on the device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p src
  -- * to the memory area pointed to by \p offset bytes from the start of symbol
  -- * \p symbol. The memory areas may not overlap. \p symbol is a variable that
  -- * resides in global or constant memory space. \p kind can be either
  -- * ::cudaMemcpyHostToDevice, ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault.
  -- * Passing ::cudaMemcpyDefault is recommended, in which case the type of transfer
  -- * is inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * ::cudaMemcpyToSymbolAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument. If
  -- * \p kind is ::cudaMemcpyHostToDevice and \p stream is non-zero, the copy
  -- * may overlap with operations in other streams.
  -- *
  -- * \param symbol - Device symbol address
  -- * \param src    - Source memory address
  -- * \param count  - Size in bytes to copy
  -- * \param offset - Offset from start of symbol in bytes
  -- * \param kind   - Type of transfer
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidSymbol,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- * \note_string_api_deprecation
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyFromSymbolAsync
  --  

   function cudaMemcpyToSymbolAsync
     (symbol : System.Address;
      src : System.Address;
      count : stddef_h.size_t;
      offset : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4920
   pragma Import (C, cudaMemcpyToSymbolAsync, "cudaMemcpyToSymbolAsync");

  --*
  -- * \brief Copies data from the given symbol on the device
  -- *
  -- * Copies \p count bytes from the memory area pointed to by \p offset bytes
  -- * from the start of symbol \p symbol to the memory area pointed to by \p dst.
  -- * The memory areas may not overlap. \p symbol is a variable that resides in
  -- * global or constant memory space. \p kind can be either
  -- * ::cudaMemcpyDeviceToHost, ::cudaMemcpyDeviceToDevice, or ::cudaMemcpyDefault.
  -- * Passing ::cudaMemcpyDefault is recommended, in which case the type of transfer
  -- * is inferred from the pointer values. However, ::cudaMemcpyDefault is only
  -- * allowed on systems that support unified virtual addressing.
  -- *
  -- * ::cudaMemcpyFromSymbolAsync() is asynchronous with respect to the host, so
  -- * the call may return before the copy is complete. The copy can optionally be
  -- * associated to a stream by passing a non-zero \p stream argument. If \p kind
  -- * is ::cudaMemcpyDeviceToHost and \p stream is non-zero, the copy may overlap
  -- * with operations in other streams.
  -- *
  -- * \param dst    - Destination memory address
  -- * \param symbol - Device symbol address
  -- * \param count  - Size in bytes to copy
  -- * \param offset - Offset from start of symbol in bytes
  -- * \param kind   - Type of transfer
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidSymbol,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidMemcpyDirection
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- * \note_string_api_deprecation
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpy2D, ::cudaMemcpyToArray,
  -- * ::cudaMemcpy2DToArray, ::cudaMemcpyFromArray, ::cudaMemcpy2DFromArray,
  -- * ::cudaMemcpyArrayToArray, ::cudaMemcpy2DArrayToArray, ::cudaMemcpyToSymbol,
  -- * ::cudaMemcpyFromSymbol, ::cudaMemcpyAsync, ::cudaMemcpy2DAsync,
  -- * ::cudaMemcpyToArrayAsync, ::cudaMemcpy2DToArrayAsync,
  -- * ::cudaMemcpyFromArrayAsync, ::cudaMemcpy2DFromArrayAsync,
  -- * ::cudaMemcpyToSymbolAsync
  --  

   function cudaMemcpyFromSymbolAsync
     (dst : System.Address;
      symbol : System.Address;
      count : stddef_h.size_t;
      offset : stddef_h.size_t;
      kind : driver_types_h.cudaMemcpyKind;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4966
   pragma Import (C, cudaMemcpyFromSymbolAsync, "cudaMemcpyFromSymbolAsync");

  --*
  -- * \brief Initializes or sets device memory to a value
  -- *
  -- * Fills the first \p count bytes of the memory area pointed to by \p devPtr
  -- * with the constant byte value \p value.
  -- *
  -- * Note that this function is asynchronous with respect to the host unless
  -- * \p devPtr refers to pinned host memory.
  -- *
  -- * \param devPtr - Pointer to device memory
  -- * \param value  - Value to set for each byte of specified memory
  -- * \param count  - Size in bytes to set
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer
  -- * \notefnerr
  -- * \note_memset
  -- *
  -- * \sa ::cudaMemset2D, ::cudaMemset3D, ::cudaMemsetAsync,
  -- * ::cudaMemset2DAsync, ::cudaMemset3DAsync
  --  

   function cudaMemset
     (devPtr : System.Address;
      value : int;
      count : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:4992
   pragma Import (C, cudaMemset, "cudaMemset");

  --*
  -- * \brief Initializes or sets device memory to a value
  -- *
  -- * Sets to the specified value \p value a matrix (\p height rows of \p width
  -- * bytes each) pointed to by \p dstPtr. \p pitch is the width in bytes of the
  -- * 2D array pointed to by \p dstPtr, including any padding added to the end
  -- * of each row. This function performs fastest when the pitch is one that has
  -- * been passed back by ::cudaMallocPitch().
  -- *
  -- * Note that this function is asynchronous with respect to the host unless
  -- * \p devPtr refers to pinned host memory.
  -- *
  -- * \param devPtr - Pointer to 2D device memory
  -- * \param pitch  - Pitch in bytes of 2D device memory
  -- * \param value  - Value to set for each byte of specified memory
  -- * \param width  - Width of matrix set (columns in bytes)
  -- * \param height - Height of matrix set (rows)
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer
  -- * \notefnerr
  -- * \note_memset
  -- *
  -- * \sa ::cudaMemset, ::cudaMemset3D, ::cudaMemsetAsync,
  -- * ::cudaMemset2DAsync, ::cudaMemset3DAsync
  --  

   function cudaMemset2D
     (devPtr : System.Address;
      pitch : stddef_h.size_t;
      value : int;
      width : stddef_h.size_t;
      height : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5022
   pragma Import (C, cudaMemset2D, "cudaMemset2D");

  --*
  -- * \brief Initializes or sets device memory to a value
  -- *
  -- * Initializes each element of a 3D array to the specified value \p value.
  -- * The object to initialize is defined by \p pitchedDevPtr. The \p pitch field
  -- * of \p pitchedDevPtr is the width in memory in bytes of the 3D array pointed
  -- * to by \p pitchedDevPtr, including any padding added to the end of each row.
  -- * The \p xsize field specifies the logical width of each row in bytes, while
  -- * the \p ysize field specifies the height of each 2D slice in rows.
  -- *
  -- * The extents of the initialized region are specified as a \p width in bytes,
  -- * a \p height in rows, and a \p depth in slices.
  -- *
  -- * Extents with \p width greater than or equal to the \p xsize of
  -- * \p pitchedDevPtr may perform significantly faster than extents narrower
  -- * than the \p xsize. Secondarily, extents with \p height equal to the
  -- * \p ysize of \p pitchedDevPtr will perform faster than when the \p height is
  -- * shorter than the \p ysize.
  -- *
  -- * This function performs fastest when the \p pitchedDevPtr has been allocated
  -- * by ::cudaMalloc3D().
  -- *
  -- * Note that this function is asynchronous with respect to the host unless
  -- * \p pitchedDevPtr refers to pinned host memory.
  -- *
  -- * \param pitchedDevPtr - Pointer to pitched device memory
  -- * \param value         - Value to set for each byte of specified memory
  -- * \param extent        - Size parameters for where to set device memory (\p width field in bytes)
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer
  -- * \notefnerr
  -- * \note_memset
  -- *
  -- * \sa ::cudaMemset, ::cudaMemset2D,
  -- * ::cudaMemsetAsync, ::cudaMemset2DAsync, ::cudaMemset3DAsync,
  -- * ::cudaMalloc3D, ::make_cudaPitchedPtr,
  -- * ::make_cudaExtent
  --  

   function cudaMemset3D
     (pitchedDevPtr : driver_types_h.cudaPitchedPtr;
      value : int;
      extent : driver_types_h.cudaExtent) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5065
   pragma Import (C, cudaMemset3D, "cudaMemset3D");

  --*
  -- * \brief Initializes or sets device memory to a value
  -- *
  -- * Fills the first \p count bytes of the memory area pointed to by \p devPtr
  -- * with the constant byte value \p value.
  -- *
  -- * ::cudaMemsetAsync() is asynchronous with respect to the host, so
  -- * the call may return before the memset is complete. The operation can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument.
  -- * If \p stream is non-zero, the operation may overlap with operations in other streams.
  -- *
  -- * The device version of this function only handles device to device copies and
  -- * cannot be given local or shared pointers.
  -- *
  -- * \param devPtr - Pointer to device memory
  -- * \param value  - Value to set for each byte of specified memory
  -- * \param count  - Size in bytes to set
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer
  -- * \notefnerr
  -- * \note_memset
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemset, ::cudaMemset2D, ::cudaMemset3D,
  -- * ::cudaMemset2DAsync, ::cudaMemset3DAsync
  --  

   function cudaMemsetAsync
     (devPtr : System.Address;
      value : int;
      count : stddef_h.size_t;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5097
   pragma Import (C, cudaMemsetAsync, "cudaMemsetAsync");

  --*
  -- * \brief Initializes or sets device memory to a value
  -- *
  -- * Sets to the specified value \p value a matrix (\p height rows of \p width
  -- * bytes each) pointed to by \p dstPtr. \p pitch is the width in bytes of the
  -- * 2D array pointed to by \p dstPtr, including any padding added to the end
  -- * of each row. This function performs fastest when the pitch is one that has
  -- * been passed back by ::cudaMallocPitch().
  -- *
  -- * ::cudaMemset2DAsync() is asynchronous with respect to the host, so
  -- * the call may return before the memset is complete. The operation can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument.
  -- * If \p stream is non-zero, the operation may overlap with operations in other streams.
  -- *
  -- * The device version of this function only handles device to device copies and
  -- * cannot be given local or shared pointers.
  -- *
  -- * \param devPtr - Pointer to 2D device memory
  -- * \param pitch  - Pitch in bytes of 2D device memory
  -- * \param value  - Value to set for each byte of specified memory
  -- * \param width  - Width of matrix set (columns in bytes)
  -- * \param height - Height of matrix set (rows)
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer
  -- * \notefnerr
  -- * \note_memset
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemset, ::cudaMemset2D, ::cudaMemset3D,
  -- * ::cudaMemsetAsync, ::cudaMemset3DAsync
  --  

   function cudaMemset2DAsync
     (devPtr : System.Address;
      pitch : stddef_h.size_t;
      value : int;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5134
   pragma Import (C, cudaMemset2DAsync, "cudaMemset2DAsync");

  --*
  -- * \brief Initializes or sets device memory to a value
  -- *
  -- * Initializes each element of a 3D array to the specified value \p value.
  -- * The object to initialize is defined by \p pitchedDevPtr. The \p pitch field
  -- * of \p pitchedDevPtr is the width in memory in bytes of the 3D array pointed
  -- * to by \p pitchedDevPtr, including any padding added to the end of each row.
  -- * The \p xsize field specifies the logical width of each row in bytes, while
  -- * the \p ysize field specifies the height of each 2D slice in rows.
  -- *
  -- * The extents of the initialized region are specified as a \p width in bytes,
  -- * a \p height in rows, and a \p depth in slices.
  -- *
  -- * Extents with \p width greater than or equal to the \p xsize of
  -- * \p pitchedDevPtr may perform significantly faster than extents narrower
  -- * than the \p xsize. Secondarily, extents with \p height equal to the
  -- * \p ysize of \p pitchedDevPtr will perform faster than when the \p height is
  -- * shorter than the \p ysize.
  -- *
  -- * This function performs fastest when the \p pitchedDevPtr has been allocated
  -- * by ::cudaMalloc3D().
  -- *
  -- * ::cudaMemset3DAsync() is asynchronous with respect to the host, so
  -- * the call may return before the memset is complete. The operation can optionally
  -- * be associated to a stream by passing a non-zero \p stream argument.
  -- * If \p stream is non-zero, the operation may overlap with operations in other streams.
  -- *
  -- * The device version of this function only handles device to device copies and
  -- * cannot be given local or shared pointers.
  -- *
  -- * \param pitchedDevPtr - Pointer to pitched device memory
  -- * \param value         - Value to set for each byte of specified memory
  -- * \param extent        - Size parameters for where to set device memory (\p width field in bytes)
  -- * \param stream - Stream identifier
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer
  -- * \notefnerr
  -- * \note_memset
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemset, ::cudaMemset2D, ::cudaMemset3D,
  -- * ::cudaMemsetAsync, ::cudaMemset2DAsync,
  -- * ::cudaMalloc3D, ::make_cudaPitchedPtr,
  -- * ::make_cudaExtent
  --  

   function cudaMemset3DAsync
     (pitchedDevPtr : driver_types_h.cudaPitchedPtr;
      value : int;
      extent : driver_types_h.cudaExtent;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5184
   pragma Import (C, cudaMemset3DAsync, "cudaMemset3DAsync");

  --*
  -- * \brief Finds the address associated with a CUDA symbol
  -- *
  -- * Returns in \p *devPtr the address of symbol \p symbol on the device.
  -- * \p symbol is a variable that resides in global or constant memory space.
  -- * If \p symbol cannot be found, or if \p symbol is not declared in the
  -- * global or constant memory space, \p *devPtr is unchanged and the error
  -- * ::cudaErrorInvalidSymbol is returned.
  -- *
  -- * \param devPtr - Return device pointer associated with symbol
  -- * \param symbol - Device symbol address
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidSymbol
  -- * \notefnerr
  -- * \note_string_api_deprecation
  -- *
  -- * \sa \ref ::cudaGetSymbolAddress(void**, const T&) "cudaGetSymbolAddress (C++ API)",
  -- * \ref ::cudaGetSymbolSize(size_t*, const void*) "cudaGetSymbolSize (C API)"
  --  

   function cudaGetSymbolAddress (devPtr : System.Address; symbol : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5207
   pragma Import (C, cudaGetSymbolAddress, "cudaGetSymbolAddress");

  --*
  -- * \brief Finds the size of the object associated with a CUDA symbol
  -- *
  -- * Returns in \p *size the size of symbol \p symbol. \p symbol is a variable that
  -- * resides in global or constant memory space. If \p symbol cannot be found, or
  -- * if \p symbol is not declared in global or constant memory space, \p *size is
  -- * unchanged and the error ::cudaErrorInvalidSymbol is returned.
  -- *
  -- * \param size   - Size of object associated with symbol
  -- * \param symbol - Device symbol address
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidSymbol
  -- * \notefnerr
  -- * \note_string_api_deprecation
  -- *
  -- * \sa \ref ::cudaGetSymbolAddress(void**, const void*) "cudaGetSymbolAddress (C API)",
  -- * \ref ::cudaGetSymbolSize(size_t*, const T&) "cudaGetSymbolSize (C++ API)"
  --  

   function cudaGetSymbolSize (size : access stddef_h.size_t; symbol : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5229
   pragma Import (C, cudaGetSymbolSize, "cudaGetSymbolSize");

  --*
  -- * \brief Prefetches memory to the specified destination device
  -- *
  -- * Prefetches memory to the specified destination device.  \p devPtr is the 
  -- * base device pointer of the memory to be prefetched and \p dstDevice is the 
  -- * destination device. \p count specifies the number of bytes to copy. \p stream
  -- * is the stream in which the operation is enqueued. The memory range must refer
  -- * to managed memory allocated via ::cudaMallocManaged or declared via __managed__ variables.
  -- *
  -- * Passing in cudaCpuDeviceId for \p dstDevice will prefetch the data to host memory. If
  -- * \p dstDevice is a GPU, then the device attribute ::cudaDevAttrConcurrentManagedAccess
  -- * must be non-zero. Additionally, \p stream must be associated with a device that has a
  -- * non-zero value for the device attribute ::cudaDevAttrConcurrentManagedAccess.
  -- *
  -- * The start address and end address of the memory range will be rounded down and rounded up
  -- * respectively to be aligned to CPU page size before the prefetch operation is enqueued
  -- * in the stream.
  -- *
  -- * If no physical memory has been allocated for this region, then this memory region
  -- * will be populated and mapped on the destination device. If there's insufficient
  -- * memory to prefetch the desired region, the Unified Memory driver may evict pages from other
  -- * ::cudaMallocManaged allocations to host memory in order to make room. Device memory
  -- * allocated using ::cudaMalloc or ::cudaMallocArray will not be evicted.
  -- *
  -- * By default, any mappings to the previous location of the migrated pages are removed and
  -- * mappings for the new location are only setup on \p dstDevice. The exact behavior however
  -- * also depends on the settings applied to this memory range via ::cudaMemAdvise as described
  -- * below:
  -- *
  -- * If ::cudaMemAdviseSetReadMostly was set on any subset of this memory range,
  -- * then that subset will create a read-only copy of the pages on \p dstDevice.
  -- *
  -- * If ::cudaMemAdviseSetPreferredLocation was called on any subset of this memory
  -- * range, then the pages will be migrated to \p dstDevice even if \p dstDevice is not the
  -- * preferred location of any pages in the memory range.
  -- *
  -- * If ::cudaMemAdviseSetAccessedBy was called on any subset of this memory range,
  -- * then mappings to those pages from all the appropriate processors are updated to
  -- * refer to the new location if establishing such a mapping is possible. Otherwise,
  -- * those mappings are cleared.
  -- *
  -- * Note that this API is not required for functionality and only serves to improve performance
  -- * by allowing the application to migrate data to a suitable location before it is accessed.
  -- * Memory accesses to this range are always coherent and are allowed even when the data is
  -- * actively being migrated.
  -- *
  -- * Note that this function is asynchronous with respect to the host and all work
  -- * on other devices.
  -- *
  -- * \param devPtr    - Pointer to be prefetched
  -- * \param count     - Size in bytes
  -- * \param dstDevice - Destination device to prefetch to
  -- * \param stream    - Stream to enqueue prefetch operation
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpyPeer, ::cudaMemcpyAsync,
  -- * ::cudaMemcpy3DPeerAsync, ::cudaMemAdvise
  --  

   function cudaMemPrefetchAsync
     (devPtr : System.Address;
      count : stddef_h.size_t;
      dstDevice : int;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5296
   pragma Import (C, cudaMemPrefetchAsync, "cudaMemPrefetchAsync");

  --*
  -- * \brief Advise about the usage of a given memory range
  -- *
  -- * Advise the Unified Memory subsystem about the usage pattern for the memory range
  -- * starting at \p devPtr with a size of \p count bytes. The start address and end address of the memory
  -- * range will be rounded down and rounded up respectively to be aligned to CPU page size before the
  -- * advice is applied. The memory range must refer to managed memory allocated via ::cudaMallocManaged
  -- * or declared via __managed__ variables.
  -- *
  -- * The \p advice parameter can take the following values:
  -- * - ::cudaMemAdviseSetReadMostly: This implies that the data is mostly going to be read
  -- * from and only occasionally written to. Any read accesses from any processor to this region will create a
  -- * read-only copy of at least the accessed pages in that processor's memory. Additionally, if ::cudaMemPrefetchAsync
  -- * is called on this region, it will create a read-only copy of the data on the destination processor.
  -- * If any processor writes to this region, all copies of the corresponding page will be invalidated
  -- * except for the one where the write occurred. The \p device argument is ignored for this advice.
  -- * Note that for a page to be read-duplicated, the accessing processor must either be the CPU or a GPU
  -- * that has a non-zero value for the device attribute ::cudaDevAttrConcurrentManagedAccess.
  -- * Also, if a context is created on a device that does not have the device attribute
  -- * ::cudaDevAttrConcurrentManagedAccess set, then read-duplication will not occur until
  -- * all such contexts are destroyed.
  -- * - ::cudaMemAdviceUnsetReadMostly: Undoes the effect of ::cudaMemAdviceReadMostly and also prevents the
  -- * Unified Memory driver from attempting heuristic read-duplication on the memory range. Any read-duplicated
  -- * copies of the data will be collapsed into a single copy. The location for the collapsed
  -- * copy will be the preferred location if the page has a preferred location and one of the read-duplicated
  -- * copies was resident at that location. Otherwise, the location chosen is arbitrary.
  -- * - ::cudaMemAdviseSetPreferredLocation: This advice sets the preferred location for the
  -- * data to be the memory belonging to \p device. Passing in cudaCpuDeviceId for \p device sets the
  -- * preferred location as host memory. If \p device is a GPU, then it must have a non-zero value for the
  -- * device attribute ::cudaDevAttrConcurrentManagedAccess. Setting the preferred location
  -- * does not cause data to migrate to that location immediately. Instead, it guides the migration policy
  -- * when a fault occurs on that memory region. If the data is already in its preferred location and the
  -- * faulting processor can establish a mapping without requiring the data to be migrated, then
  -- * data migration will be avoided. On the other hand, if the data is not in its preferred location
  -- * or if a direct mapping cannot be established, then it will be migrated to the processor accessing
  -- * it. It is important to note that setting the preferred location does not prevent data prefetching
  -- * done using ::cudaMemPrefetchAsync.
  -- * Having a preferred location can override the page thrash detection and resolution logic in the Unified
  -- * Memory driver. Normally, if a page is detected to be constantly thrashing between for example host and device
  -- * memory, the page may eventually be pinned to host memory by the Unified Memory driver. But
  -- * if the preferred location is set as device memory, then the page will continue to thrash indefinitely.
  -- * If ::cudaMemAdviseSetReadMostly is also set on this memory region or any subset of it, then the
  -- * policies associated with that advice will override the policies of this advice.
  -- * - ::cudaMemAdviseUnsetPreferredLocation: Undoes the effect of ::cudaMemAdviseSetPreferredLocation
  -- * and changes the preferred location to none.
  -- * - ::cudaMemAdviseSetAccessedBy: This advice implies that the data will be accessed by \p device.
  -- * Passing in ::cudaCpuDeviceId for \p device will set the advice for the CPU. If \p device is a GPU, then
  -- * the device attribute ::cudaDevAttrConcurrentManagedAccess must be non-zero.
  -- * This advice does not cause data migration and has no impact on the location of the data per se. Instead,
  -- * it causes the data to always be mapped in the specified processor's page tables, as long as the
  -- * location of the data permits a mapping to be established. If the data gets migrated for any reason,
  -- * the mappings are updated accordingly.
  -- * This advice is recommended in scenarios where data locality is not important, but avoiding faults is.
  -- * Consider for example a system containing multiple GPUs with peer-to-peer access enabled, where the
  -- * data located on one GPU is occasionally accessed by peer GPUs. In such scenarios, migrating data
  -- * over to the other GPUs is not as important because the accesses are infrequent and the overhead of
  -- * migration may be too high. But preventing faults can still help improve performance, and so having
  -- * a mapping set up in advance is useful. Note that on CPU access of this data, the data may be migrated
  -- * to host memory because the CPU typically cannot access device memory directly. Any GPU that had the
  -- * ::cudaMemAdviceSetAccessedBy flag set for this data will now have its mapping updated to point to the
  -- * page in host memory.
  -- * If ::cudaMemAdviseSetReadMostly is also set on this memory region or any subset of it, then the
  -- * policies associated with that advice will override the policies of this advice. Additionally, if the
  -- * preferred location of this memory region or any subset of it is also \p device, then the policies
  -- * associated with ::cudaMemAdviseSetPreferredLocation will override the policies of this advice.
  -- * - ::cudaMemAdviseUnsetAccessedBy: Undoes the effect of ::cudaMemAdviseSetAccessedBy. Any mappings to
  -- * the data from \p device may be removed at any time causing accesses to result in non-fatal page faults.
  -- *
  -- * \param devPtr - Pointer to memory to set the advice for
  -- * \param count  - Size in bytes of the memory range
  -- * \param advice - Advice to be applied for the specified memory range
  -- * \param device - Device to apply the advice for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemcpy, ::cudaMemcpyPeer, ::cudaMemcpyAsync,
  -- * ::cudaMemcpy3DPeerAsync, ::cudaMemPrefetchAsync
  --  

   function cudaMemAdvise
     (devPtr : System.Address;
      count : stddef_h.size_t;
      advice : driver_types_h.cudaMemoryAdvise;
      device : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5382
   pragma Import (C, cudaMemAdvise, "cudaMemAdvise");

  --*
  --* \brief Query an attribute of a given memory range
  --*
  --* Query an attribute about the memory range starting at \p devPtr with a size of \p count bytes. The
  --* memory range must refer to managed memory allocated via ::cudaMallocManaged or declared via
  --* __managed__ variables.
  --*
  --* The \p attribute parameter can take the following values:
  --* - ::cudaMemRangeAttributeReadMostly: If this attribute is specified, \p data will be interpreted
  --* as a 32-bit integer, and \p dataSize must be 4. The result returned will be 1 if all pages in the given
  --* memory range have read-duplication enabled, or 0 otherwise.
  --* - ::cudaMemRangeAttributePreferredLocation: If this attribute is specified, \p data will be
  --* interpreted as a 32-bit integer, and \p dataSize must be 4. The result returned will be a GPU device
  --* id if all pages in the memory range have that GPU as their preferred location, or it will be cudaCpuDeviceId
  --* if all pages in the memory range have the CPU as their preferred location, or it will be cudaInvalidDeviceId
  --* if either all the pages don't have the same preferred location or some of the pages don't have a
  --* preferred location at all. Note that the actual location of the pages in the memory range at the time of
  --* the query may be different from the preferred location.
  --* - ::cudaMemRangeAttributeAccessedBy: If this attribute is specified, \p data will be interpreted
  --* as an array of 32-bit integers, and \p dataSize must be a non-zero multiple of 4. The result returned
  --* will be a list of device ids that had ::cudaMemAdviceSetAccessedBy set for that entire memory range.
  --* If any device does not have that advice set for the entire memory range, that device will not be included.
  --* If \p data is larger than the number of devices that have that advice set for that memory range,
  --* cudaInvalidDeviceId will be returned in all the extra space provided. For ex., if \p dataSize is 12
  --* (i.e. \p data has 3 elements) and only device 0 has the advice set, then the result returned will be
  --* { 0, cudaInvalidDeviceId, cudaInvalidDeviceId }. If \p data is smaller than the number of devices that have
  --* that advice set, then only as many devices will be returned as can fit in the array. There is no
  --* guarantee on which specific devices will be returned, however.
  --* - ::cudaMemRangeAttributeLastPrefetchLocation: If this attribute is specified, \p data will be
  --* interpreted as a 32-bit integer, and \p dataSize must be 4. The result returned will be the last location
  --* to which all pages in the memory range were prefetched explicitly via ::cudaMemPrefetchAsync. This will either be
  --* a GPU id or cudaCpuDeviceId depending on whether the last location for prefetch was a GPU or the CPU
  --* respectively. If any page in the memory range was never explicitly prefetched or if all pages were not
  --* prefetched to the same location, cudaInvalidDeviceId will be returned. Note that this simply returns the
  --* last location that the applicaton requested to prefetch the memory range to. It gives no indication as to
  --* whether the prefetch operation to that location has completed or even begun.
  --*
  --* \param data      - A pointers to a memory location where the result
  --*                    of each attribute query will be written to.
  --* \param dataSize  - Array containing the size of data
  --* \param attribute - The attribute to query
  --* \param devPtr    - Start of the range to query
  --* \param count     - Size of the range to query
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- * \note_async
  -- * \note_null_stream
  -- *
  -- * \sa ::cudaMemRangeGetAttributes, ::cudaMemPrefetchAsync,
  -- * ::cudaMemAdvise
  --  

   function cudaMemRangeGetAttribute
     (data : System.Address;
      dataSize : stddef_h.size_t;
      attribute : driver_types_h.cudaMemRangeAttribute;
      devPtr : System.Address;
      count : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5438
   pragma Import (C, cudaMemRangeGetAttribute, "cudaMemRangeGetAttribute");

  --*
  -- * \brief Query attributes of a given memory range.
  -- *
  -- * Query attributes of the memory range starting at \p devPtr with a size of \p count bytes. The
  -- * memory range must refer to managed memory allocated via ::cudaMallocManaged or declared via
  -- * __managed__ variables. The \p attributes array will be interpreted to have \p numAttributes
  -- * entries. The \p dataSizes array will also be interpreted to have \p numAttributes entries.
  -- * The results of the query will be stored in \p data.
  -- *
  -- * The list of supported attributes are given below. Please refer to ::cudaMemRangeGetAttribute for
  -- * attribute descriptions and restrictions.
  -- *
  -- * - ::cudaMemRangeAttributeReadMostly
  -- * - ::cudaMemRangeAttributePreferredLocation
  -- * - ::cudaMemRangeAttributeAccessedBy
  -- * - ::cudaMemRangeAttributeLastPrefetchLocation
  -- *
  -- * \param data          - A two-dimensional array containing pointers to memory
  -- *                        locations where the result of each attribute query will be written to.
  -- * \param dataSizes     - Array containing the sizes of each result
  -- * \param attributes    - An array of attributes to query
  -- *                        (numAttributes and the number of attributes in this array should match)
  -- * \param numAttributes - Number of attributes to query
  -- * \param devPtr        - Start of the range to query
  -- * \param count         - Size of the range to query
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaMemRangeGetAttribute, ::cudaMemAdvise
  -- * ::cudaMemPrefetchAsync
  --  

   function cudaMemRangeGetAttributes
     (data : System.Address;
      dataSizes : access stddef_h.size_t;
      attributes : access driver_types_h.cudaMemRangeAttribute;
      numAttributes : stddef_h.size_t;
      devPtr : System.Address;
      count : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5474
   pragma Import (C, cudaMemRangeGetAttributes, "cudaMemRangeGetAttributes");

  --* @}  
  -- END CUDART_MEMORY  
  --*
  -- * \defgroup CUDART_UNIFIED Unified Addressing
  -- *
  -- * ___MANBRIEF___ unified addressing functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the unified addressing functions of the CUDA 
  -- * runtime application programming interface.
  -- *
  -- * @{
  -- *
  -- * \section CUDART_UNIFIED_overview Overview
  -- *
  -- * CUDA devices can share a unified address space with the host.  
  -- * For these devices there is no distinction between a device
  -- * pointer and a host pointer -- the same pointer value may be 
  -- * used to access memory from the host program and from a kernel 
  -- * running on the device (with exceptions enumerated below).
  -- *
  -- * \section CUDART_UNIFIED_support Supported Platforms
  -- * 
  -- * Whether or not a device supports unified addressing may be 
  -- * queried by calling ::cudaGetDeviceProperties() with the device 
  -- * property ::cudaDeviceProp::unifiedAddressing.
  -- *
  -- * Unified addressing is automatically enabled in 64-bit processes .
  -- *
  -- * Unified addressing is not yet supported on Windows Vista or
  -- * Windows 7 for devices that do not use the TCC driver model.
  -- *
  -- * \section CUDART_UNIFIED_lookup Looking Up Information from Pointer Values
  -- *
  -- * It is possible to look up information about the memory which backs a 
  -- * pointer value.  For instance, one may want to know if a pointer points
  -- * to host or device memory.  As another example, in the case of device 
  -- * memory, one may want to know on which CUDA device the memory 
  -- * resides.  These properties may be queried using the function 
  -- * ::cudaPointerGetAttributes()
  -- *
  -- * Since pointers are unique, it is not necessary to specify information
  -- * about the pointers specified to ::cudaMemcpy() and other copy functions.  
  -- * The copy direction ::cudaMemcpyDefault may be used to specify that the 
  -- * CUDA runtime should infer the location of the pointer from its value.
  -- *
  -- * \section CUDART_UNIFIED_automaphost Automatic Mapping of Host Allocated Host Memory
  -- *
  -- * All host memory allocated through all devices using ::cudaMallocHost() and
  -- * ::cudaHostAlloc() is always directly accessible from all devices that 
  -- * support unified addressing.  This is the case regardless of whether or 
  -- * not the flags ::cudaHostAllocPortable and ::cudaHostAllocMapped are 
  -- * specified.
  -- *
  -- * The pointer value through which allocated host memory may be accessed 
  -- * in kernels on all devices that support unified addressing is the same 
  -- * as the pointer value through which that memory is accessed on the host.
  -- * It is not necessary to call ::cudaHostGetDevicePointer() to get the device 
  -- * pointer for these allocations.  
  -- *
  -- * Note that this is not the case for memory allocated using the flag
  -- * ::cudaHostAllocWriteCombined, as discussed below.
  -- *
  -- * \section CUDART_UNIFIED_autopeerregister Direct Access of Peer Memory
  -- 
  -- * Upon enabling direct access from a device that supports unified addressing 
  -- * to another peer device that supports unified addressing using 
  -- * ::cudaDeviceEnablePeerAccess() all memory allocated in the peer device using 
  -- * ::cudaMalloc() and ::cudaMallocPitch() will immediately be accessible 
  -- * by the current device.  The device pointer value through 
  -- * which any peer's memory may be accessed in the current device 
  -- * is the same pointer value through which that memory may be 
  -- * accessed from the peer device. 
  -- *
  -- * \section CUDART_UNIFIED_exceptions Exceptions, Disjoint Addressing
  -- * 
  -- * Not all memory may be accessed on devices through the same pointer
  -- * value through which they are accessed on the host.  These exceptions
  -- * are host memory registered using ::cudaHostRegister() and host memory
  -- * allocated using the flag ::cudaHostAllocWriteCombined.  For these 
  -- * exceptions, there exists a distinct host and device address for the
  -- * memory.  The device address is guaranteed to not overlap any valid host
  -- * pointer range and is guaranteed to have the same value across all devices
  -- * that support unified addressing.  
  -- * 
  -- * This device address may be queried using ::cudaHostGetDevicePointer() 
  -- * when a device using unified addressing is current.  Either the host 
  -- * or the unified device pointer value may be used to refer to this memory 
  -- * in ::cudaMemcpy() and similar functions using the ::cudaMemcpyDefault 
  -- * memory direction.
  -- *
  --  

  --*
  -- * \brief Returns attributes about a specified pointer
  -- *
  -- * Returns in \p *attributes the attributes of the pointer \p ptr.
  -- * If pointer was not allocated in, mapped by or registered with context
  -- * supporting unified addressing ::cudaErrorInvalidValue is returned.
  -- *
  -- * The ::cudaPointerAttributes structure is defined as:
  -- * \code
  --    struct cudaPointerAttributes {
  --        enum cudaMemoryType memoryType;
  --        int device;
  --        void *devicePointer;
  --        void *hostPointer;
  --        int isManaged;
  --    }
  --    \endcode
  -- * In this structure, the individual fields mean
  -- *
  -- * - \ref ::cudaPointerAttributes::memoryType "memoryType" identifies the physical 
  -- *   location of the memory associated with pointer \p ptr.  It can be
  -- *   ::cudaMemoryTypeHost for host memory or ::cudaMemoryTypeDevice for device
  -- *   memory.
  -- *
  -- * - \ref ::cudaPointerAttributes::device "device" is the device against which
  -- *   \p ptr was allocated.  If \p ptr has memory type ::cudaMemoryTypeDevice
  -- *   then this identifies the device on which the memory referred to by \p ptr
  -- *   physically resides.  If \p ptr has memory type ::cudaMemoryTypeHost then this
  -- *   identifies the device which was current when the allocation was made
  -- *   (and if that device is deinitialized then this allocation will vanish
  -- *   with that device's state).
  -- *
  -- * - \ref ::cudaPointerAttributes::devicePointer "devicePointer" is
  -- *   the device pointer alias through which the memory referred to by \p ptr
  -- *   may be accessed on the current device.
  -- *   If the memory referred to by \p ptr cannot be accessed directly by the 
  -- *   current device then this is NULL.  
  -- *
  -- * - \ref ::cudaPointerAttributes::hostPointer "hostPointer" is
  -- *   the host pointer alias through which the memory referred to by \p ptr
  -- *   may be accessed on the host.
  -- *   If the memory referred to by \p ptr cannot be accessed directly by the
  -- *   host then this is NULL.
  -- *
  -- * - \ref ::cudaPointerAttributes::isManaged "isManaged" indicates if
  -- *   the pointer \p ptr points to managed memory or not.
  -- *
  -- * \param attributes - Attributes for the specified pointer
  -- * \param ptr        - Pointer to get attributes for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaGetDeviceCount, ::cudaGetDevice, ::cudaSetDevice,
  -- * ::cudaChooseDevice
  --  

   function cudaPointerGetAttributes (attributes : access driver_types_h.cudaPointerAttributes; ptr : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5627
   pragma Import (C, cudaPointerGetAttributes, "cudaPointerGetAttributes");

  --* @}  
  -- END CUDART_UNIFIED  
  --*
  -- * \defgroup CUDART_PEER Peer Device Memory Access
  -- *
  -- * ___MANBRIEF___ peer device memory access functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the peer device memory access functions of the CUDA runtime
  -- * application programming interface.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Queries if a device may directly access a peer device's memory.
  -- *
  -- * Returns in \p *canAccessPeer a value of 1 if device \p device is capable of
  -- * directly accessing memory from \p peerDevice and 0 otherwise.  If direct
  -- * access of \p peerDevice from \p device is possible, then access may be
  -- * enabled by calling ::cudaDeviceEnablePeerAccess().
  -- *
  -- * \param canAccessPeer - Returned access capability
  -- * \param device        - Device from which allocations on \p peerDevice are to
  -- *                        be directly accessed.
  -- * \param peerDevice    - Device on which the allocations to be directly accessed 
  -- *                        by \p device reside.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceEnablePeerAccess,
  -- * ::cudaDeviceDisablePeerAccess
  --  

   function cudaDeviceCanAccessPeer
     (canAccessPeer : access int;
      device : int;
      peerDevice : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5665
   pragma Import (C, cudaDeviceCanAccessPeer, "cudaDeviceCanAccessPeer");

  --*
  -- * \brief Enables direct access to memory allocations on a peer device.
  -- *
  -- * On success, all allocations from \p peerDevice will immediately be accessible by
  -- * the current device.  They will remain accessible until access is explicitly
  -- * disabled using ::cudaDeviceDisablePeerAccess() or either device is reset using
  -- * ::cudaDeviceReset().
  -- *
  -- * Note that access granted by this call is unidirectional and that in order to access
  -- * memory on the current device from \p peerDevice, a separate symmetric call 
  -- * to ::cudaDeviceEnablePeerAccess() is required.
  -- *
  -- * Each device can support a system-wide maximum of eight peer connections.
  -- *
  -- * Peer access is not supported in 32 bit applications.
  -- *
  -- * Returns ::cudaErrorInvalidDevice if ::cudaDeviceCanAccessPeer() indicates
  -- * that the current device cannot directly access memory from \p peerDevice.
  -- *
  -- * Returns ::cudaErrorPeerAccessAlreadyEnabled if direct access of
  -- * \p peerDevice from the current device has already been enabled.
  -- *
  -- * Returns ::cudaErrorInvalidValue if \p flags is not 0.
  -- *
  -- * \param peerDevice  - Peer device to enable direct access to from the current device
  -- * \param flags       - Reserved for future use and must be set to 0
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidDevice,
  -- * ::cudaErrorPeerAccessAlreadyEnabled,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceCanAccessPeer,
  -- * ::cudaDeviceDisablePeerAccess
  --  

   function cudaDeviceEnablePeerAccess (peerDevice : int; flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5704
   pragma Import (C, cudaDeviceEnablePeerAccess, "cudaDeviceEnablePeerAccess");

  --*
  -- * \brief Disables direct access to memory allocations on a peer device.
  -- *
  -- * Returns ::cudaErrorPeerAccessNotEnabled if direct access to memory on
  -- * \p peerDevice has not yet been enabled from the current device.
  -- *
  -- * \param peerDevice - Peer device to disable direct access to
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorPeerAccessNotEnabled,
  -- * ::cudaErrorInvalidDevice
  -- * \notefnerr
  -- *
  -- * \sa ::cudaDeviceCanAccessPeer,
  -- * ::cudaDeviceEnablePeerAccess
  --  

   function cudaDeviceDisablePeerAccess (peerDevice : int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5723
   pragma Import (C, cudaDeviceDisablePeerAccess, "cudaDeviceDisablePeerAccess");

  --* @}  
  -- END CUDART_PEER  
  --* \defgroup CUDART_OPENGL OpenGL Interoperability  
  --* \defgroup CUDART_OPENGL_DEPRECATED OpenGL Interoperability [DEPRECATED]  
  --* \defgroup CUDART_D3D9 Direct3D 9 Interoperability  
  --* \defgroup CUDART_D3D9_DEPRECATED Direct3D 9 Interoperability [DEPRECATED]  
  --* \defgroup CUDART_D3D10 Direct3D 10 Interoperability  
  --* \defgroup CUDART_D3D10_DEPRECATED Direct3D 10 Interoperability [DEPRECATED]  
  --* \defgroup CUDART_D3D11 Direct3D 11 Interoperability  
  --* \defgroup CUDART_D3D11_DEPRECATED Direct3D 11 Interoperability [DEPRECATED]  
  --* \defgroup CUDART_VDPAU VDPAU Interoperability  
  --* \defgroup CUDART_EGL EGL Interoperability  
  --*
  -- * \defgroup CUDART_INTEROP Graphics Interoperability
  -- *
  -- * ___MANBRIEF___ graphics interoperability functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the graphics interoperability functions of the CUDA
  -- * runtime application programming interface.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Unregisters a graphics resource for access by CUDA
  -- *
  -- * Unregisters the graphics resource \p resource so it is not accessible by
  -- * CUDA unless registered again.
  -- *
  -- * If \p resource is invalid then ::cudaErrorInvalidResourceHandle is
  -- * returned.
  -- *
  -- * \param resource - Resource to unregister
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorUnknown
  -- * \notefnerr
  -- *
  -- * \sa
  -- * ::cudaGraphicsD3D9RegisterResource,
  -- * ::cudaGraphicsD3D10RegisterResource,
  -- * ::cudaGraphicsD3D11RegisterResource,
  -- * ::cudaGraphicsGLRegisterBuffer,
  -- * ::cudaGraphicsGLRegisterImage
  --  

   function cudaGraphicsUnregisterResource (resource : driver_types_h.cudaGraphicsResource_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5783
   pragma Import (C, cudaGraphicsUnregisterResource, "cudaGraphicsUnregisterResource");

  --*
  -- * \brief Set usage flags for mapping a graphics resource
  -- *
  -- * Set \p flags for mapping the graphics resource \p resource.
  -- *
  -- * Changes to \p flags will take effect the next time \p resource is mapped.
  -- * The \p flags argument may be any of the following:
  -- * - ::cudaGraphicsMapFlagsNone: Specifies no hints about how \p resource will
  -- *     be used. It is therefore assumed that CUDA may read from or write to \p resource.
  -- * - ::cudaGraphicsMapFlagsReadOnly: Specifies that CUDA will not write to \p resource.
  -- * - ::cudaGraphicsMapFlagsWriteDiscard: Specifies CUDA will not read from \p resource and will
  -- *   write over the entire contents of \p resource, so none of the data
  -- *   previously stored in \p resource will be preserved.
  -- *
  -- * If \p resource is presently mapped for access by CUDA then ::cudaErrorUnknown is returned.
  -- * If \p flags is not one of the above values then ::cudaErrorInvalidValue is returned.
  -- *
  -- * \param resource - Registered resource to set flags for
  -- * \param flags    - Parameters for resource mapping
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorUnknown,
  -- * \notefnerr
  -- *
  -- * \sa
  -- * ::cudaGraphicsMapResources
  --  

   function cudaGraphicsResourceSetMapFlags (resource : driver_types_h.cudaGraphicsResource_t; flags : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5815
   pragma Import (C, cudaGraphicsResourceSetMapFlags, "cudaGraphicsResourceSetMapFlags");

  --*
  -- * \brief Map graphics resources for access by CUDA
  -- *
  -- * Maps the \p count graphics resources in \p resources for access by CUDA.
  -- *
  -- * The resources in \p resources may be accessed by CUDA until they
  -- * are unmapped. The graphics API from which \p resources were registered
  -- * should not access any resources while they are mapped by CUDA. If an
  -- * application does so, the results are undefined.
  -- *
  -- * This function provides the synchronization guarantee that any graphics calls
  -- * issued before ::cudaGraphicsMapResources() will complete before any subsequent CUDA
  -- * work issued in \p stream begins.
  -- *
  -- * If \p resources contains any duplicate entries then ::cudaErrorInvalidResourceHandle
  -- * is returned. If any of \p resources are presently mapped for access by
  -- * CUDA then ::cudaErrorUnknown is returned.
  -- *
  -- * \param count     - Number of resources to map
  -- * \param resources - Resources to map for CUDA
  -- * \param stream    - Stream for synchronization
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorUnknown
  -- * \note_null_stream
  -- * \notefnerr
  -- *
  -- * \sa
  -- * ::cudaGraphicsResourceGetMappedPointer,
  -- * ::cudaGraphicsSubResourceGetMappedArray,
  -- * ::cudaGraphicsUnmapResources
  --  

   function cudaGraphicsMapResources
     (count : int;
      resources : System.Address;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5851
   pragma Import (C, cudaGraphicsMapResources, "cudaGraphicsMapResources");

  --*
  -- * \brief Unmap graphics resources.
  -- *
  -- * Unmaps the \p count graphics resources in \p resources.
  -- *
  -- * Once unmapped, the resources in \p resources may not be accessed by CUDA
  -- * until they are mapped again.
  -- *
  -- * This function provides the synchronization guarantee that any CUDA work issued
  -- * in \p stream before ::cudaGraphicsUnmapResources() will complete before any
  -- * subsequently issued graphics work begins.
  -- *
  -- * If \p resources contains any duplicate entries then ::cudaErrorInvalidResourceHandle
  -- * is returned. If any of \p resources are not presently mapped for access by
  -- * CUDA then ::cudaErrorUnknown is returned.
  -- *
  -- * \param count     - Number of resources to unmap
  -- * \param resources - Resources to unmap
  -- * \param stream    - Stream for synchronization
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorUnknown
  -- * \note_null_stream
  -- * \notefnerr
  -- *
  -- * \sa
  -- * ::cudaGraphicsMapResources
  --  

   function cudaGraphicsUnmapResources
     (count : int;
      resources : System.Address;
      stream : driver_types_h.cudaStream_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5883
   pragma Import (C, cudaGraphicsUnmapResources, "cudaGraphicsUnmapResources");

  --*
  -- * \brief Get an device pointer through which to access a mapped graphics resource.
  -- *
  -- * Returns in \p *devPtr a pointer through which the mapped graphics resource
  -- * \p resource may be accessed.
  -- * Returns in \p *size the size of the memory in bytes which may be accessed from that pointer.
  -- * The value set in \p devPtr may change every time that \p resource is mapped.
  -- *
  -- * If \p resource is not a buffer then it cannot be accessed via a pointer and
  -- * ::cudaErrorUnknown is returned.
  -- * If \p resource is not mapped then ::cudaErrorUnknown is returned.
  -- * *
  -- * \param devPtr     - Returned pointer through which \p resource may be accessed
  -- * \param size       - Returned size of the buffer accessible starting at \p *devPtr
  -- * \param resource   - Mapped resource to access
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorUnknown
  -- * \notefnerr
  -- *
  -- * \sa
  -- * ::cudaGraphicsMapResources,
  -- * ::cudaGraphicsSubResourceGetMappedArray
  --  

   function cudaGraphicsResourceGetMappedPointer
     (devPtr : System.Address;
      size : access stddef_h.size_t;
      resource : driver_types_h.cudaGraphicsResource_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5912
   pragma Import (C, cudaGraphicsResourceGetMappedPointer, "cudaGraphicsResourceGetMappedPointer");

  --*
  -- * \brief Get an array through which to access a subresource of a mapped graphics resource.
  -- *
  -- * Returns in \p *array an array through which the subresource of the mapped
  -- * graphics resource \p resource which corresponds to array index \p arrayIndex
  -- * and mipmap level \p mipLevel may be accessed.  The value set in \p array may
  -- * change every time that \p resource is mapped.
  -- *
  -- * If \p resource is not a texture then it cannot be accessed via an array and
  -- * ::cudaErrorUnknown is returned.
  -- * If \p arrayIndex is not a valid array index for \p resource then
  -- * ::cudaErrorInvalidValue is returned.
  -- * If \p mipLevel is not a valid mipmap level for \p resource then
  -- * ::cudaErrorInvalidValue is returned.
  -- * If \p resource is not mapped then ::cudaErrorUnknown is returned.
  -- *
  -- * \param array       - Returned array through which a subresource of \p resource may be accessed
  -- * \param resource    - Mapped resource to access
  -- * \param arrayIndex  - Array index for array textures or cubemap face
  -- *                      index as defined by ::cudaGraphicsCubeFace for
  -- *                      cubemap textures for the subresource to access
  -- * \param mipLevel    - Mipmap level for the subresource to access
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorUnknown
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGraphicsResourceGetMappedPointer
  --  

   function cudaGraphicsSubResourceGetMappedArray
     (c_array : System.Address;
      resource : driver_types_h.cudaGraphicsResource_t;
      arrayIndex : unsigned;
      mipLevel : unsigned) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5946
   pragma Import (C, cudaGraphicsSubResourceGetMappedArray, "cudaGraphicsSubResourceGetMappedArray");

  --*
  -- * \brief Get a mipmapped array through which to access a mapped graphics resource.
  -- *
  -- * Returns in \p *mipmappedArray a mipmapped array through which the mapped
  -- * graphics resource \p resource may be accessed. The value set in \p mipmappedArray may
  -- * change every time that \p resource is mapped.
  -- *
  -- * If \p resource is not a texture then it cannot be accessed via an array and
  -- * ::cudaErrorUnknown is returned.
  -- * If \p resource is not mapped then ::cudaErrorUnknown is returned.
  -- *
  -- * \param mipmappedArray - Returned mipmapped array through which \p resource may be accessed
  -- * \param resource       - Mapped resource to access
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidResourceHandle,
  -- * ::cudaErrorUnknown
  -- * \notefnerr
  -- *
  -- * \sa ::cudaGraphicsResourceGetMappedPointer
  --  

   function cudaGraphicsResourceGetMappedMipmappedArray (mipmappedArray : System.Address; resource : driver_types_h.cudaGraphicsResource_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:5971
   pragma Import (C, cudaGraphicsResourceGetMappedMipmappedArray, "cudaGraphicsResourceGetMappedMipmappedArray");

  --* @}  
  -- END CUDART_INTEROP  
  --*
  -- * \defgroup CUDART_TEXTURE Texture Reference Management
  -- *
  -- * ___MANBRIEF___ texture reference management functions of the CUDA runtime
  -- * API (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the low level texture reference management functions
  -- * of the CUDA runtime application programming interface.
  -- *
  -- * Some functions have overloaded C++ API template versions documented separately in the
  -- * \ref CUDART_HIGHLEVEL "C++ API Routines" module.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Get the channel descriptor of an array
  -- *
  -- * Returns in \p *desc the channel descriptor of the CUDA array \p array.
  -- *
  -- * \param desc  - Channel format
  -- * \param array - Memory array on device
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct textureReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaUnbindTexture (C API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)"
  --  

   function cudaGetChannelDesc (desc : access driver_types_h.cudaChannelFormatDesc; c_array : driver_types_h.cudaArray_const_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6011
   pragma Import (C, cudaGetChannelDesc, "cudaGetChannelDesc");

  --*
  -- * \brief Returns a channel descriptor using the specified format
  -- *
  -- * Returns a channel descriptor with format \p f and number of bits of each
  -- * component \p x, \p y, \p z, and \p w.  The ::cudaChannelFormatDesc is
  -- * defined as:
  -- * \code
  --  struct cudaChannelFormatDesc {
  --    int x, y, z, w;
  --    enum cudaChannelFormatKind f;
  --  };
  -- * \endcode
  -- *
  -- * where ::cudaChannelFormatKind is one of ::cudaChannelFormatKindSigned,
  -- * ::cudaChannelFormatKindUnsigned, or ::cudaChannelFormatKindFloat.
  -- *
  -- * \param x - X component
  -- * \param y - Y component
  -- * \param z - Z component
  -- * \param w - W component
  -- * \param f - Channel format
  -- *
  -- * \return
  -- * Channel descriptor with format \p f
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(void) "cudaCreateChannelDesc (C++ API)",
  -- * ::cudaGetChannelDesc, ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct textureReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaUnbindTexture (C API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)"
  --  

   function cudaCreateChannelDesc
     (x : int;
      y : int;
      z : int;
      w : int;
      f : driver_types_h.cudaChannelFormatKind) return driver_types_h.cudaChannelFormatDesc;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6046
   pragma Import (C, cudaCreateChannelDesc, "cudaCreateChannelDesc");

  --*
  -- * \brief Binds a memory area to a texture
  -- *
  -- * Binds \p size bytes of the memory area pointed to by \p devPtr to the
  -- * texture reference \p texref. \p desc describes how the memory is interpreted
  -- * when fetching values from the texture. Any memory previously bound to
  -- * \p texref is unbound.
  -- *
  -- * Since the hardware enforces an alignment requirement on texture base
  -- * addresses,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture()"
  -- * returns in \p *offset a byte offset that
  -- * must be applied to texture fetches in order to read from the desired memory.
  -- * This offset must be divided by the texel size and passed to kernels that
  -- * read from the texture so they can be applied to the ::tex1Dfetch() function.
  -- * If the device memory pointer was returned from ::cudaMalloc(), the offset is
  -- * guaranteed to be 0 and NULL may be passed as the \p offset parameter.
  -- *
  -- * The total number of elements (or texels) in the linear address range
  -- * cannot exceed ::cudaDeviceProp::maxTexture1DLinear[0].
  -- * The number of elements is computed as (\p size / elementSize),
  -- * where elementSize is determined from \p desc.
  -- *
  -- * \param offset - Offset in bytes
  -- * \param texref - Texture to bind
  -- * \param devPtr - Memory area on device
  -- * \param desc   - Channel format
  -- * \param size   - Size of the memory area pointed to by devPtr
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidTexture
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetChannelDesc, ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct texture< T, dim, readMode>&, const void*, const struct cudaChannelFormatDesc&, size_t) "cudaBindTexture (C++ API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct textureReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaUnbindTexture (C API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)"
  --  

   function cudaBindTexture
     (offset : access stddef_h.size_t;
      texref : access constant texture_types_h.textureReference;
      devPtr : System.Address;
      desc : access constant driver_types_h.cudaChannelFormatDesc;
      size : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6093
   pragma Import (C, cudaBindTexture, "cudaBindTexture");

  --*
  -- * \brief Binds a 2D memory area to a texture
  -- *
  -- * Binds the 2D memory area pointed to by \p devPtr to the
  -- * texture reference \p texref. The size of the area is constrained by
  -- * \p width in texel units, \p height in texel units, and \p pitch in byte
  -- * units. \p desc describes how the memory is interpreted when fetching values
  -- * from the texture. Any memory previously bound to \p texref is unbound.
  -- *
  -- * Since the hardware enforces an alignment requirement on texture base
  -- * addresses, ::cudaBindTexture2D() returns in \p *offset a byte offset that
  -- * must be applied to texture fetches in order to read from the desired memory.
  -- * This offset must be divided by the texel size and passed to kernels that
  -- * read from the texture so they can be applied to the ::tex2D() function.
  -- * If the device memory pointer was returned from ::cudaMalloc(), the offset is
  -- * guaranteed to be 0 and NULL may be passed as the \p offset parameter.
  -- *
  -- * \p width and \p height, which are specified in elements (or texels), cannot
  -- * exceed ::cudaDeviceProp::maxTexture2DLinear[0] and ::cudaDeviceProp::maxTexture2DLinear[1]
  -- * respectively. \p pitch, which is specified in bytes, cannot exceed
  -- * ::cudaDeviceProp::maxTexture2DLinear[2].
  -- *
  -- * The driver returns ::cudaErrorInvalidValue if \p pitch is not a multiple of
  -- * ::cudaDeviceProp::texturePitchAlignment.
  -- *
  -- * \param offset - Offset in bytes
  -- * \param texref - Texture reference to bind
  -- * \param devPtr - 2D memory area on device
  -- * \param desc   - Channel format
  -- * \param width  - Width in texel units
  -- * \param height - Height in texel units
  -- * \param pitch  - Pitch in bytes
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidTexture
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetChannelDesc, ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct texture< T, dim, readMode>&, const void*, const struct cudaChannelFormatDesc&, size_t, size_t, size_t) "cudaBindTexture2D (C++ API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct texture<T, dim, readMode>&, const void*, size_t, size_t, size_t) "cudaBindTexture2D (C++ API, inherited channel descriptor)",
  -- * \ref ::cudaBindTextureToArray(const struct textureReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)"
  --  

   function cudaBindTexture2D
     (offset : access stddef_h.size_t;
      texref : access constant texture_types_h.textureReference;
      devPtr : System.Address;
      desc : access constant driver_types_h.cudaChannelFormatDesc;
      width : stddef_h.size_t;
      height : stddef_h.size_t;
      pitch : stddef_h.size_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6144
   pragma Import (C, cudaBindTexture2D, "cudaBindTexture2D");

  --*
  -- * \brief Binds an array to a texture
  -- *
  -- * Binds the CUDA array \p array to the texture reference \p texref.
  -- * \p desc describes how the memory is interpreted when fetching values from
  -- * the texture. Any CUDA array previously bound to \p texref is unbound.
  -- *
  -- * \param texref - Texture to bind
  -- * \param array  - Memory array on device
  -- * \param desc   - Channel format
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidTexture
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetChannelDesc, ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct texture< T, dim, readMode>&, cudaArray_const_t, const struct cudaChannelFormatDesc&) "cudaBindTextureToArray (C++ API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaUnbindTexture (C API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)"
  --  

   function cudaBindTextureToArray
     (texref : access constant texture_types_h.textureReference;
      c_array : driver_types_h.cudaArray_const_t;
      desc : access constant driver_types_h.cudaChannelFormatDesc) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6172
   pragma Import (C, cudaBindTextureToArray, "cudaBindTextureToArray");

  --*
  -- * \brief Binds a mipmapped array to a texture
  -- *
  -- * Binds the CUDA mipmapped array \p mipmappedArray to the texture reference \p texref.
  -- * \p desc describes how the memory is interpreted when fetching values from
  -- * the texture. Any CUDA mipmapped array previously bound to \p texref is unbound.
  -- *
  -- * \param texref         - Texture to bind
  -- * \param mipmappedArray - Memory mipmapped array on device
  -- * \param desc           - Channel format
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidDevicePointer,
  -- * ::cudaErrorInvalidTexture
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetChannelDesc, ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct texture< T, dim, readMode>&, cudaArray_const_t, const struct cudaChannelFormatDesc&) "cudaBindTextureToArray (C++ API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaUnbindTexture (C API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)"
  --  

   function cudaBindTextureToMipmappedArray
     (texref : access constant texture_types_h.textureReference;
      mipmappedArray : driver_types_h.cudaMipmappedArray_const_t;
      desc : access constant driver_types_h.cudaChannelFormatDesc) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6200
   pragma Import (C, cudaBindTextureToMipmappedArray, "cudaBindTextureToMipmappedArray");

  --*
  -- * \brief Unbinds a texture
  -- *
  -- * Unbinds the texture bound to \p texref.
  -- *
  -- * \param texref - Texture to unbind
  -- *
  -- * \return
  -- * ::cudaSuccess
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetChannelDesc, ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct textureReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaUnbindTexture(const struct texture< T, dim, readMode>&) "cudaUnbindTexture (C++ API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)"
  --  

   function cudaUnbindTexture (texref : access constant texture_types_h.textureReference) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6221
   pragma Import (C, cudaUnbindTexture, "cudaUnbindTexture");

  --*
  -- * \brief Get the alignment offset of a texture
  -- *
  -- * Returns in \p *offset the offset that was returned when texture reference
  -- * \p texref was bound.
  -- *
  -- * \param offset - Offset of texture reference in bytes
  -- * \param texref - Texture to get offset of
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidTexture,
  -- * ::cudaErrorInvalidTextureBinding
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetChannelDesc, ::cudaGetTextureReference,
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct textureReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaUnbindTexture (C API)",
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct texture< T, dim, readMode>&) "cudaGetTextureAlignmentOffset (C++ API)"
  --  

   function cudaGetTextureAlignmentOffset (offset : access stddef_h.size_t; texref : access constant texture_types_h.textureReference) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6246
   pragma Import (C, cudaGetTextureAlignmentOffset, "cudaGetTextureAlignmentOffset");

  --*
  -- * \brief Get the texture reference associated with a symbol
  -- *
  -- * Returns in \p *texref the structure associated to the texture reference
  -- * defined by symbol \p symbol.
  -- *
  -- * \param texref - Texture reference associated with symbol
  -- * \param symbol - Texture to get reference for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidTexture
  -- * \notefnerr
  -- * \note_string_api_deprecation_50
  -- *
  -- * \sa \ref ::cudaCreateChannelDesc(int, int, int, int, cudaChannelFormatKind) "cudaCreateChannelDesc (C API)",
  -- * ::cudaGetChannelDesc,
  -- * \ref ::cudaGetTextureAlignmentOffset(size_t*, const struct textureReference*) "cudaGetTextureAlignmentOffset (C API)",
  -- * \ref ::cudaBindTexture(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t) "cudaBindTexture (C API)",
  -- * \ref ::cudaBindTexture2D(size_t*, const struct textureReference*, const void*, const struct cudaChannelFormatDesc*, size_t, size_t, size_t) "cudaBindTexture2D (C API)",
  -- * \ref ::cudaBindTextureToArray(const struct textureReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindTextureToArray (C API)",
  -- * \ref ::cudaUnbindTexture(const struct textureReference*) "cudaUnbindTexture (C API)"
  --  

   function cudaGetTextureReference (texref : System.Address; symbol : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6271
   pragma Import (C, cudaGetTextureReference, "cudaGetTextureReference");

  --* @}  
  -- END CUDART_TEXTURE  
  --*
  -- * \defgroup CUDART_SURFACE Surface Reference Management
  -- *
  -- * ___MANBRIEF___ surface reference management functions of the CUDA runtime
  -- * API (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the low level surface reference management functions
  -- * of the CUDA runtime application programming interface.
  -- *
  -- * Some functions have overloaded C++ API template versions documented separately in the
  -- * \ref CUDART_HIGHLEVEL "C++ API Routines" module.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Binds an array to a surface
  -- *
  -- * Binds the CUDA array \p array to the surface reference \p surfref.
  -- * \p desc describes how the memory is interpreted when fetching values from
  -- * the surface. Any CUDA array previously bound to \p surfref is unbound.
  -- *
  -- * \param surfref - Surface to bind
  -- * \param array  - Memory array on device
  -- * \param desc   - Channel format
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue,
  -- * ::cudaErrorInvalidSurface
  -- * \notefnerr
  -- *
  -- * \sa \ref ::cudaBindSurfaceToArray(const struct surface< T, dim>&, cudaArray_const_t, const struct cudaChannelFormatDesc&) "cudaBindSurfaceToArray (C++ API)",
  -- * \ref ::cudaBindSurfaceToArray(const struct surface< T, dim>&, cudaArray_const_t) "cudaBindSurfaceToArray (C++ API, inherited channel descriptor)",
  -- * ::cudaGetSurfaceReference
  --  

   function cudaBindSurfaceToArray
     (surfref : access constant surface_types_h.surfaceReference;
      c_array : driver_types_h.cudaArray_const_t;
      desc : access constant driver_types_h.cudaChannelFormatDesc) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6311
   pragma Import (C, cudaBindSurfaceToArray, "cudaBindSurfaceToArray");

  --*
  -- * \brief Get the surface reference associated with a symbol
  -- *
  -- * Returns in \p *surfref the structure associated to the surface reference
  -- * defined by symbol \p symbol.
  -- *
  -- * \param surfref - Surface reference associated with symbol
  -- * \param symbol - Surface to get reference for
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidSurface
  -- * \notefnerr
  -- * \note_string_api_deprecation_50
  -- *
  -- * \sa \ref ::cudaBindSurfaceToArray(const struct surfaceReference*, cudaArray_const_t, const struct cudaChannelFormatDesc*) "cudaBindSurfaceToArray (C API)"
  --  

   function cudaGetSurfaceReference (surfref : System.Address; symbol : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6330
   pragma Import (C, cudaGetSurfaceReference, "cudaGetSurfaceReference");

  --* @}  
  -- END CUDART_SURFACE  
  --*
  -- * \defgroup CUDART_TEXTURE_OBJECT Texture Object Management
  -- *
  -- * ___MANBRIEF___ texture object management functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the low level texture object management functions
  -- * of the CUDA runtime application programming interface. The texture
  -- * object API is only supported on devices of compute capability 3.0 or higher.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Creates a texture object
  -- *
  -- * Creates a texture object and returns it in \p pTexObject. \p pResDesc describes
  -- * the data to texture from. \p pTexDesc describes how the data should be sampled.
  -- * \p pResViewDesc is an optional argument that specifies an alternate format for
  -- * the data described by \p pResDesc, and also describes the subresource region
  -- * to restrict access to when texturing. \p pResViewDesc can only be specified if
  -- * the type of resource is a CUDA array or a CUDA mipmapped array.
  -- *
  -- * Texture objects are only supported on devices of compute capability 3.0 or higher.
  -- * Additionally, a texture object is an opaque value, and, as such, should only be
  -- * accessed through CUDA API calls.
  -- *
  -- * The ::cudaResourceDesc structure is defined as:
  -- * \code
  --        struct cudaResourceDesc {
  --	        enum cudaResourceType resType;
  --        	
  --	        union {
  --		        struct {
  --			        cudaArray_t array;
  --		        } array;
  --                struct {
  --                    cudaMipmappedArray_t mipmap;
  --                } mipmap;
  --		        struct {
  --			        void *devPtr;
  --			        struct cudaChannelFormatDesc desc;
  --			        size_t sizeInBytes;
  --		        } linear;
  --		        struct {
  --			        void *devPtr;
  --			        struct cudaChannelFormatDesc desc;
  --			        size_t width;
  --			        size_t height;
  --			        size_t pitchInBytes;
  --		        } pitch2D;
  --	        } res;
  --        };
  -- * \endcode
  -- * where:
  -- * - ::cudaResourceDesc::resType specifies the type of resource to texture from.
  -- * CUresourceType is defined as:
  -- * \code
  --        enum cudaResourceType {
  --            cudaResourceTypeArray          = 0x00,
  --            cudaResourceTypeMipmappedArray = 0x01,
  --            cudaResourceTypeLinear         = 0x02,
  --            cudaResourceTypePitch2D        = 0x03
  --        };
  -- * \endcode
  -- *
  -- * \par
  -- * If ::cudaResourceDesc::resType is set to ::cudaResourceTypeArray, ::cudaResourceDesc::res::array::array
  -- * must be set to a valid CUDA array handle.
  -- *
  -- * \par
  -- * If ::cudaResourceDesc::resType is set to ::cudaResourceTypeMipmappedArray, ::cudaResourceDesc::res::mipmap::mipmap
  -- * must be set to a valid CUDA mipmapped array handle and ::cudaTextureDesc::normalizedCoords must be set to true.
  -- *
  -- * \par
  -- * If ::cudaResourceDesc::resType is set to ::cudaResourceTypeLinear, ::cudaResourceDesc::res::linear::devPtr
  -- * must be set to a valid device pointer, that is aligned to ::cudaDeviceProp::textureAlignment.
  -- * ::cudaResourceDesc::res::linear::desc describes the format and the number of components per array element. ::cudaResourceDesc::res::linear::sizeInBytes
  -- * specifies the size of the array in bytes. The total number of elements in the linear address range cannot exceed 
  -- * ::cudaDeviceProp::maxTexture1DLinear. The number of elements is computed as (sizeInBytes / sizeof(desc)).
  -- *
  -- * \par
  -- * If ::cudaResourceDesc::resType is set to ::cudaResourceTypePitch2D, ::cudaResourceDesc::res::pitch2D::devPtr
  -- * must be set to a valid device pointer, that is aligned to ::cudaDeviceProp::textureAlignment.
  -- * ::cudaResourceDesc::res::pitch2D::desc describes the format and the number of components per array element. ::cudaResourceDesc::res::pitch2D::width
  -- * and ::cudaResourceDesc::res::pitch2D::height specify the width and height of the array in elements, and cannot exceed
  -- * ::cudaDeviceProp::maxTexture2DLinear[0] and ::cudaDeviceProp::maxTexture2DLinear[1] respectively.
  -- * ::cudaResourceDesc::res::pitch2D::pitchInBytes specifies the pitch between two rows in bytes and has to be aligned to 
  -- * ::cudaDeviceProp::texturePitchAlignment. Pitch cannot exceed ::cudaDeviceProp::maxTexture2DLinear[2].
  -- *
  -- *
  -- * The ::cudaTextureDesc struct is defined as
  -- * \code
  --        struct cudaTextureDesc {
  --            enum cudaTextureAddressMode addressMode[3];
  --            enum cudaTextureFilterMode  filterMode;
  --            enum cudaTextureReadMode    readMode;
  --            int                         sRGB;
  --            float                       borderColor[4];
  --            int                         normalizedCoords;
  --            unsigned int                maxAnisotropy;
  --            enum cudaTextureFilterMode  mipmapFilterMode;
  --            float                       mipmapLevelBias;
  --            float                       minMipmapLevelClamp;
  --            float                       maxMipmapLevelClamp;
  --        };
  -- * \endcode
  -- * where
  -- * - ::cudaTextureDesc::addressMode specifies the addressing mode for each dimension of the texture data. ::cudaTextureAddressMode is defined as:
  -- *   \code
  --        enum cudaTextureAddressMode {
  --            cudaAddressModeWrap   = 0,
  --            cudaAddressModeClamp  = 1,
  --            cudaAddressModeMirror = 2,
  --            cudaAddressModeBorder = 3
  --        };
  -- *   \endcode
  -- *   This is ignored if ::cudaResourceDesc::resType is ::cudaResourceTypeLinear. Also, if ::cudaTextureDesc::normalizedCoords
  -- *   is set to zero, ::cudaAddressModeWrap and ::cudaAddressModeMirror won't be supported and will be switched to ::cudaAddressModeClamp.
  -- *
  -- * - ::cudaTextureDesc::filterMode specifies the filtering mode to be used when fetching from the texture. ::cudaTextureFilterMode is defined as:
  -- *   \code
  --        enum cudaTextureFilterMode {
  --            cudaFilterModePoint  = 0,
  --            cudaFilterModeLinear = 1
  --        };
  -- *   \endcode
  -- *   This is ignored if ::cudaResourceDesc::resType is ::cudaResourceTypeLinear.
  -- *
  -- * - ::cudaTextureDesc::readMode specifies whether integer data should be converted to floating point or not. ::cudaTextureReadMode is defined as:
  -- *   \code
  --        enum cudaTextureReadMode {
  --            cudaReadModeElementType     = 0,
  --            cudaReadModeNormalizedFloat = 1
  --        };
  -- *   \endcode
  -- *   Note that this applies only to 8-bit and 16-bit integer formats. 32-bit integer format would not be promoted, regardless of 
  -- *   whether or not this ::cudaTextureDesc::readMode is set ::cudaReadModeNormalizedFloat is specified.
  -- *
  -- * - ::cudaTextureDesc::sRGB specifies whether sRGB to linear conversion should be performed during texture fetch.
  -- *
  -- * - ::cudaTextureDesc::borderColor specifies the float values of color. where:
  -- *   ::cudaTextureDesc::borderColor[0] contains value of 'R', 
  -- *   ::cudaTextureDesc::borderColor[1] contains value of 'G',
  -- *   ::cudaTextureDesc::borderColor[2] contains value of 'B', 
  -- *   ::cudaTextureDesc::borderColor[3] contains value of 'A'
  -- *   Note that application using integer border color values will need to <reinterpret_cast> these values to float.
  -- *   The values are set only when the addressing mode specified by ::cudaTextureDesc::addressMode is cudaAddressModeBorder.
  -- *
  -- * - ::cudaTextureDesc::normalizedCoords specifies whether the texture coordinates will be normalized or not.
  -- *
  -- * - ::cudaTextureDesc::maxAnisotropy specifies the maximum anistropy ratio to be used when doing anisotropic filtering. This value will be
  -- *   clamped to the range [1,16].
  -- *
  -- * - ::cudaTextureDesc::mipmapFilterMode specifies the filter mode when the calculated mipmap level lies between two defined mipmap levels.
  -- *
  -- * - ::cudaTextureDesc::mipmapLevelBias specifies the offset to be applied to the calculated mipmap level.
  -- *
  -- * - ::cudaTextureDesc::minMipmapLevelClamp specifies the lower end of the mipmap level range to clamp access to.
  -- *
  -- * - ::cudaTextureDesc::maxMipmapLevelClamp specifies the upper end of the mipmap level range to clamp access to.
  -- *
  -- *
  -- * The ::cudaResourceViewDesc struct is defined as
  -- * \code
  --        struct cudaResourceViewDesc {
  --            enum cudaResourceViewFormat format;
  --            size_t                      width;
  --            size_t                      height;
  --            size_t                      depth;
  --            unsigned int                firstMipmapLevel;
  --            unsigned int                lastMipmapLevel;
  --            unsigned int                firstLayer;
  --            unsigned int                lastLayer;
  --        };
  -- * \endcode
  -- * where:
  -- * - ::cudaResourceViewDesc::format specifies how the data contained in the CUDA array or CUDA mipmapped array should
  -- *   be interpreted. Note that this can incur a change in size of the texture data. If the resource view format is a block
  -- *   compressed format, then the underlying CUDA array or CUDA mipmapped array has to have a 32-bit unsigned integer format
  -- *   with 2 or 4 channels, depending on the block compressed format. For ex., BC1 and BC4 require the underlying CUDA array to have
  -- *   a 32-bit unsigned int with 2 channels. The other BC formats require the underlying resource to have the same 32-bit unsigned int
  -- *   format but with 4 channels.
  -- *
  -- * - ::cudaResourceViewDesc::width specifies the new width of the texture data. If the resource view format is a block
  -- *   compressed format, this value has to be 4 times the original width of the resource. For non block compressed formats,
  -- *   this value has to be equal to that of the original resource.
  -- *
  -- * - ::cudaResourceViewDesc::height specifies the new height of the texture data. If the resource view format is a block
  -- *   compressed format, this value has to be 4 times the original height of the resource. For non block compressed formats,
  -- *   this value has to be equal to that of the original resource.
  -- *
  -- * - ::cudaResourceViewDesc::depth specifies the new depth of the texture data. This value has to be equal to that of the
  -- *   original resource.
  -- *
  -- * - ::cudaResourceViewDesc::firstMipmapLevel specifies the most detailed mipmap level. This will be the new mipmap level zero.
  -- *   For non-mipmapped resources, this value has to be zero.::cudaTextureDesc::minMipmapLevelClamp and ::cudaTextureDesc::maxMipmapLevelClamp
  -- *   will be relative to this value. For ex., if the firstMipmapLevel is set to 2, and a minMipmapLevelClamp of 1.2 is specified,
  -- *   then the actual minimum mipmap level clamp will be 3.2.
  -- *
  -- * - ::cudaResourceViewDesc::lastMipmapLevel specifies the least detailed mipmap level. For non-mipmapped resources, this value
  -- *   has to be zero.
  -- *
  -- * - ::cudaResourceViewDesc::firstLayer specifies the first layer index for layered textures. This will be the new layer zero.
  -- *   For non-layered resources, this value has to be zero.
  -- *
  -- * - ::cudaResourceViewDesc::lastLayer specifies the last layer index for layered textures. For non-layered resources, 
  -- *   this value has to be zero.
  -- *
  -- *
  -- * \param pTexObject   - Texture object to create
  -- * \param pResDesc     - Resource descriptor
  -- * \param pTexDesc     - Texture descriptor
  -- * \param pResViewDesc - Resource view descriptor
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaDestroyTextureObject
  --  

   function cudaCreateTextureObject
     (pTexObject : access texture_types_h.cudaTextureObject_t;
      pResDesc : access constant driver_types_h.cudaResourceDesc;
      pTexDesc : access constant texture_types_h.cudaTextureDesc;
      pResViewDesc : access constant driver_types_h.cudaResourceViewDesc) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6556
   pragma Import (C, cudaCreateTextureObject, "cudaCreateTextureObject");

  --*
  -- * \brief Destroys a texture object
  -- *
  -- * Destroys the texture object specified by \p texObject.
  -- *
  -- * \param texObject - Texture object to destroy
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaCreateTextureObject
  --  

   function cudaDestroyTextureObject (texObject : texture_types_h.cudaTextureObject_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6571
   pragma Import (C, cudaDestroyTextureObject, "cudaDestroyTextureObject");

  --*
  -- * \brief Returns a texture object's resource descriptor
  -- *
  -- * Returns the resource descriptor for the texture object specified by \p texObject.
  -- *
  -- * \param pResDesc  - Resource descriptor
  -- * \param texObject - Texture object
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaCreateTextureObject
  --  

   function cudaGetTextureObjectResourceDesc (pResDesc : access driver_types_h.cudaResourceDesc; texObject : texture_types_h.cudaTextureObject_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6587
   pragma Import (C, cudaGetTextureObjectResourceDesc, "cudaGetTextureObjectResourceDesc");

  --*
  -- * \brief Returns a texture object's texture descriptor
  -- *
  -- * Returns the texture descriptor for the texture object specified by \p texObject.
  -- *
  -- * \param pTexDesc  - Texture descriptor
  -- * \param texObject - Texture object
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaCreateTextureObject
  --  

   function cudaGetTextureObjectTextureDesc (pTexDesc : access texture_types_h.cudaTextureDesc; texObject : texture_types_h.cudaTextureObject_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6603
   pragma Import (C, cudaGetTextureObjectTextureDesc, "cudaGetTextureObjectTextureDesc");

  --*
  -- * \brief Returns a texture object's resource view descriptor
  -- *
  -- * Returns the resource view descriptor for the texture object specified by \p texObject.
  -- * If no resource view was specified, ::cudaErrorInvalidValue is returned.
  -- *
  -- * \param pResViewDesc - Resource view descriptor
  -- * \param texObject    - Texture object
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaCreateTextureObject
  --  

   function cudaGetTextureObjectResourceViewDesc (pResViewDesc : access driver_types_h.cudaResourceViewDesc; texObject : texture_types_h.cudaTextureObject_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6620
   pragma Import (C, cudaGetTextureObjectResourceViewDesc, "cudaGetTextureObjectResourceViewDesc");

  --* @}  
  -- END CUDART_TEXTURE_OBJECT  
  --*
  -- * \defgroup CUDART_SURFACE_OBJECT Surface Object Management
  -- *
  -- * ___MANBRIEF___ surface object management functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the low level texture object management functions
  -- * of the CUDA runtime application programming interface. The surface object 
  -- * API is only supported on devices of compute capability 3.0 or higher.
  -- *
  -- * @{
  --  

  --*
  -- * \brief Creates a surface object
  -- *
  -- * Creates a surface object and returns it in \p pSurfObject. \p pResDesc describes
  -- * the data to perform surface load/stores on. ::cudaResourceDesc::resType must be 
  -- * ::cudaResourceTypeArray and  ::cudaResourceDesc::res::array::array
  -- * must be set to a valid CUDA array handle.
  -- *
  -- * Surface objects are only supported on devices of compute capability 3.0 or higher.
  -- * Additionally, a surface object is an opaque value, and, as such, should only be
  -- * accessed through CUDA API calls.
  -- *
  -- * \param pSurfObject - Surface object to create
  -- * \param pResDesc    - Resource descriptor
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaDestroySurfaceObject
  --  

   function cudaCreateSurfaceObject (pSurfObject : access surface_types_h.cudaSurfaceObject_t; pResDesc : access constant driver_types_h.cudaResourceDesc) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6659
   pragma Import (C, cudaCreateSurfaceObject, "cudaCreateSurfaceObject");

  --*
  -- * \brief Destroys a surface object
  -- *
  -- * Destroys the surface object specified by \p surfObject.
  -- *
  -- * \param surfObject - Surface object to destroy
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaCreateSurfaceObject
  --  

   function cudaDestroySurfaceObject (surfObject : surface_types_h.cudaSurfaceObject_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6674
   pragma Import (C, cudaDestroySurfaceObject, "cudaDestroySurfaceObject");

  --*
  -- * \brief Returns a surface object's resource descriptor
  -- * Returns the resource descriptor for the surface object specified by \p surfObject.
  -- *
  -- * \param pResDesc   - Resource descriptor
  -- * \param surfObject - Surface object
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaCreateSurfaceObject
  --  

   function cudaGetSurfaceObjectResourceDesc (pResDesc : access driver_types_h.cudaResourceDesc; surfObject : surface_types_h.cudaSurfaceObject_t) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6689
   pragma Import (C, cudaGetSurfaceObjectResourceDesc, "cudaGetSurfaceObjectResourceDesc");

  --* @}  
  -- END CUDART_SURFACE_OBJECT  
  --*
  -- * \defgroup CUDART__VERSION Version Management
  -- *
  -- * @{
  --  

  --*
  -- * \brief Returns the CUDA driver version
  -- *
  -- * Returns in \p *driverVersion the version number of the installed CUDA
  -- * driver. If no driver is installed, then 0 is returned as the driver
  -- * version (via \p driverVersion). This function automatically returns
  -- * ::cudaErrorInvalidValue if the \p driverVersion argument is NULL.
  -- *
  -- * \param driverVersion - Returns the CUDA driver version.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- * \notefnerr
  -- *
  -- * \sa ::cudaRuntimeGetVersion
  --  

   function cudaDriverGetVersion (driverVersion : access int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6716
   pragma Import (C, cudaDriverGetVersion, "cudaDriverGetVersion");

  --*
  -- * \brief Returns the CUDA Runtime version
  -- *
  -- * Returns in \p *runtimeVersion the version number of the installed CUDA
  -- * Runtime. This function automatically returns ::cudaErrorInvalidValue if
  -- * the \p runtimeVersion argument is NULL.
  -- *
  -- * \param runtimeVersion - Returns the CUDA Runtime version.
  -- *
  -- * \return
  -- * ::cudaSuccess,
  -- * ::cudaErrorInvalidValue
  -- *
  -- * \sa ::cudaDriverGetVersion
  --  

   function cudaRuntimeGetVersion (runtimeVersion : access int) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6733
   pragma Import (C, cudaRuntimeGetVersion, "cudaRuntimeGetVersion");

  --* @}  
  -- END CUDART__VERSION  
  --* \cond impl_private  
   function cudaGetExportTable (ppExportTable : System.Address; pExportTableId : System.Address) return driver_types_h.cudaError_t;  -- /usr/local/cuda-8.0/include/cuda_runtime_api.h:6738
   pragma Import (C, cudaGetExportTable, "cudaGetExportTable");

  --* \endcond impl_private  
  --*
  -- * \defgroup CUDART_HIGHLEVEL C++ API Routines
  -- *
  -- * ___MANBRIEF___ C++ high level API functions of the CUDA runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the C++ high level API functions of the CUDA runtime
  -- * application programming interface. To use these functions, your
  -- * application needs to be compiled with the \p nvcc compiler.
  -- *
  -- * \brief C++-style interface built on top of CUDA runtime API
  --  

  --*
  -- * \defgroup CUDART_DRIVER Interactions with the CUDA Driver API
  -- *
  -- * ___MANBRIEF___ interactions between CUDA Driver API and CUDA Runtime API
  -- * (___CURRENT_FILE___) ___ENDMANBRIEF___
  -- *
  -- * This section describes the interactions between the CUDA Driver API and the CUDA Runtime API
  -- *
  -- * @{
  -- *
  -- * \section CUDART_CUDA_primary Primary Contexts
  -- *
  -- * There exists a one to one relationship between CUDA devices in the CUDA Runtime
  -- * API and ::CUcontext s in the CUDA Driver API within a process.  The specific
  -- * context which the CUDA Runtime API uses for a device is called the device's
  -- * primary context.  From the perspective of the CUDA Runtime API, a device and 
  -- * its primary context are synonymous.
  -- *
  -- * \section CUDART_CUDA_init Initialization and Tear-Down
  -- *
  -- * CUDA Runtime API calls operate on the CUDA Driver API ::CUcontext which is current to
  -- * to the calling host thread.  
  -- *
  -- * The function ::cudaSetDevice() makes the primary context for the
  -- * specified device current to the calling thread by calling ::cuCtxSetCurrent().
  -- *
  -- * The CUDA Runtime API will automatically initialize the primary context for
  -- * a device at the first CUDA Runtime API call which requires an active context.
  -- * If no ::CUcontext is current to the calling thread when a CUDA Runtime API call 
  -- * which requires an active context is made, then the primary context for a device 
  -- * will be selected, made current to the calling thread, and initialized.
  -- *
  -- * The context which the CUDA Runtime API initializes will be initialized using 
  -- * the parameters specified by the CUDA Runtime API functions
  -- * ::cudaSetDeviceFlags(), 
  -- * ::cudaD3D9SetDirect3DDevice(), 
  -- * ::cudaD3D10SetDirect3DDevice(), 
  -- * ::cudaD3D11SetDirect3DDevice(), 
  -- * ::cudaGLSetGLDevice(), and
  -- * ::cudaVDPAUSetVDPAUDevice().
  -- * Note that these functions will fail with ::cudaErrorSetOnActiveProcess if they are 
  -- * called when the primary context for the specified device has already been initialized.
  -- * (or if the current device has already been initialized, in the case of 
  -- * ::cudaSetDeviceFlags()). 
  -- *
  -- * Primary contexts will remain active until they are explicitly deinitialized 
  -- * using ::cudaDeviceReset().  The function ::cudaDeviceReset() will deinitialize the 
  -- * primary context for the calling thread's current device immediately.  The context 
  -- * will remain current to all of the threads that it was current to.  The next CUDA 
  -- * Runtime API call on any thread which requires an active context will trigger the 
  -- * reinitialization of that device's primary context.
  -- *
  -- * Note that there is no reference counting of the primary context's lifetime.  It is
  -- * recommended that the primary context not be deinitialized except just before exit
  -- * or to recover from an unspecified launch failure.
  -- * 
  -- * \section CUDART_CUDA_context Context Interoperability
  -- *
  -- * Note that the use of multiple ::CUcontext s per device within a single process 
  -- * will substantially degrade performance and is strongly discouraged.  Instead,
  -- * it is highly recommended that the implicit one-to-one device-to-context mapping
  -- * for the process provided by the CUDA Runtime API be used.
  -- *
  -- * If a non-primary ::CUcontext created by the CUDA Driver API is current to a
  -- * thread then the CUDA Runtime API calls to that thread will operate on that 
  -- * ::CUcontext, with some exceptions listed below.  Interoperability between data
  -- * types is discussed in the following sections.
  -- *
  -- * The function ::cudaPointerGetAttributes() will return the error 
  -- * ::cudaErrorIncompatibleDriverContext if the pointer being queried was allocated by a 
  -- * non-primary context.  The function ::cudaDeviceEnablePeerAccess() and the rest of 
  -- * the peer access API may not be called when a non-primary ::CUcontext is current.  
  -- * To use the pointer query and peer access APIs with a context created using the 
  -- * CUDA Driver API, it is necessary that the CUDA Driver API be used to access
  -- * these features.
  -- *
  -- * All CUDA Runtime API state (e.g, global variables' addresses and values) travels
  -- * with its underlying ::CUcontext.  In particular, if a ::CUcontext is moved from one 
  -- * thread to another then all CUDA Runtime API state will move to that thread as well.
  -- *
  -- * Please note that attaching to legacy contexts (those with a version of 3010 as returned
  -- * by ::cuCtxGetApiVersion()) is not possible. The CUDA Runtime will return
  -- * ::cudaErrorIncompatibleDriverContext in such cases.
  -- *
  -- * \section CUDART_CUDA_stream Interactions between CUstream and cudaStream_t
  -- *
  -- * The types ::CUstream and ::cudaStream_t are identical and may be used interchangeably.
  -- *
  -- * \section CUDART_CUDA_event Interactions between CUevent and cudaEvent_t
  -- *
  -- * The types ::CUevent and ::cudaEvent_t are identical and may be used interchangeably.
  -- *
  -- * \section CUDART_CUDA_array Interactions between CUarray and cudaArray_t 
  -- *
  -- * The types ::CUarray and struct ::cudaArray * represent the same data type and may be used
  -- * interchangeably by casting the two types between each other.
  -- *
  -- * In order to use a ::CUarray in a CUDA Runtime API function which takes a struct ::cudaArray *,
  -- * it is necessary to explicitly cast the ::CUarray to a struct ::cudaArray *.
  -- *
  -- * In order to use a struct ::cudaArray * in a CUDA Driver API function which takes a ::CUarray,
  -- * it is necessary to explicitly cast the struct ::cudaArray * to a ::CUarray .
  -- *
  -- * \section CUDART_CUDA_graphicsResource Interactions between CUgraphicsResource and cudaGraphicsResource_t
  -- *
  -- * The types ::CUgraphicsResource and ::cudaGraphicsResource_t represent the same data type and may be used
  -- * interchangeably by casting the two types between each other.
  -- *
  -- * In order to use a ::CUgraphicsResource in a CUDA Runtime API function which takes a 
  -- * ::cudaGraphicsResource_t, it is necessary to explicitly cast the ::CUgraphicsResource 
  -- * to a ::cudaGraphicsResource_t.
  -- *
  -- * In order to use a ::cudaGraphicsResource_t in a CUDA Driver API function which takes a
  -- * ::CUgraphicsResource, it is necessary to explicitly cast the ::cudaGraphicsResource_t 
  -- * to a ::CUgraphicsResource.
  -- *
  -- * @}
  --  

  -- nvcc stubs reference the 'cudaLaunch' identifier even if it was defined
  -- to 'cudaLaunch_ptsz'. Redirect through a static inline function.
end cuda_runtime_api_h;
