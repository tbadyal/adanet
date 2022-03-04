pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with nppdefs_h;
with System;

package nppi_support_functions_h is

  -- Copyright 2009-2014 NVIDIA Corporation.  All rights reserved. 
  --  * 
  --  * NOTICE TO LICENSEE: 
  --  * 
  --  * The source code and/or documentation ("Licensed Deliverables") are 
  --  * subject to NVIDIA intellectual property rights under U.S. and 
  --  * international Copyright laws. 
  --  * 
  --  * The Licensed Deliverables contained herein are PROPRIETARY and 
  --  * CONFIDENTIAL to NVIDIA and are being provided under the terms and 
  --  * conditions of a form of NVIDIA software license agreement by and 
  --  * between NVIDIA and Licensee ("License Agreement") or electronically 
  --  * accepted by Licensee.  Notwithstanding any terms or conditions to 
  --  * the contrary in the License Agreement, reproduction or disclosure 
  --  * of the Licensed Deliverables to any third party without the express 
  --  * written consent of NVIDIA is prohibited. 
  --  * 
  --  * NOTWITHSTANDING ANY TERMS OR CONDITIONS TO THE CONTRARY IN THE 
  --  * LICENSE AGREEMENT, NVIDIA MAKES NO REPRESENTATION ABOUT THE 
  --  * SUITABILITY OF THESE LICENSED DELIVERABLES FOR ANY PURPOSE.  THEY ARE 
  --  * PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF ANY KIND. 
  --  * NVIDIA DISCLAIMS ALL WARRANTIES WITH REGARD TO THESE LICENSED 
  --  * DELIVERABLES, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY, 
  --  * NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE. 
  --  * NOTWITHSTANDING ANY TERMS OR CONDITIONS TO THE CONTRARY IN THE 
  --  * LICENSE AGREEMENT, IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY 
  --  * SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, OR ANY 
  --  * DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
  --  * WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS 
  --  * ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE 
  --  * OF THESE LICENSED DELIVERABLES. 
  --  * 
  --  * U.S. Government End Users.  These Licensed Deliverables are a 
  --  * "commercial item" as that term is defined at 48 C.F.R. 2.101 (OCT 
  --  * 1995), consisting of "commercial computer software" and "commercial 
  --  * computer software documentation" as such terms are used in 48 
  --  * C.F.R. 12.212 (SEPT 1995) and are provided to the U.S. Government 
  --  * only as a commercial end item.  Consistent with 48 C.F.R.12.212 and 
  --  * 48 C.F.R. 227.7202-1 through 227.7202-4 (JUNE 1995), all 
  --  * U.S. Government End Users acquire the Licensed Deliverables with 
  --  * only those rights set forth herein. 
  --  * 
  --  * Any use of the Licensed Deliverables in individual and commercial 
  --  * software must include, in the user documentation and internal 
  --  * comments to the code, the above Disclaimer and U.S. Government End 
  --  * Users Notice. 
  --   

  --*
  -- * \file nppi_support_functions.h
  -- * NPP Image Processing Functionality.
  -- * Image memory management
  --  

  --* @defgroup image_memory_management Memory Management
  -- *  @ingroup nppi
  -- *
  -- * Routines for allocating and deallocating pitched image storage. These methods
  -- * are provided for convenience. They allocate memory that may contain additional
  -- * padding bytes at the end of each line of pixels. Though padding is not necessary
  -- * for any of the NPP image-processing primitives to work correctly, its absense may
  -- * cause sever performance degradation compared to properly padded images.
  -- *
  -- * @{
  -- *
  -- * These functions can be found in either the nppi or nppisu libraries. Linking to only the sub-libraries that you use can significantly
  -- * save link time, application load time, and CUDA runtime startup time when using dynamic libraries.
  -- *
  --  

  --* @name Image Memory Allocation
  -- * ImageAllocator methods for 2D arrays of data. The allocators have width and height parameters
  -- * to specify the size of the image data being allocated. They return a pointer to the
  -- * newly created memory and return the numbers of bytes between successive lines. 
  -- *
  -- * If the memory allocation failed due to lack of free device memory or device memory fragmentation
  -- * the routine returns 0.
  -- *
  -- * All allocators return memory with line strides that are 
  -- * beneficial for performance. It is not mandatory to use these allocators. Any valid CUDA device-memory
  -- * pointers can be used by the NPP primitives and there are no restrictions on line strides.
  -- *
  -- * @{
  -- *
  --  

  --*
  -- * 8-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_8u_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp8u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:104
   pragma Import (C, nppiMalloc_8u_C1, "nppiMalloc_8u_C1");

  --*
  -- * 2 channel 8-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_8u_C2
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp8u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:114
   pragma Import (C, nppiMalloc_8u_C2, "nppiMalloc_8u_C2");

  --*
  -- * 3 channel 8-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_8u_C3
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp8u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:124
   pragma Import (C, nppiMalloc_8u_C3, "nppiMalloc_8u_C3");

  --*
  -- * 4 channel 8-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_8u_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp8u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:134
   pragma Import (C, nppiMalloc_8u_C4, "nppiMalloc_8u_C4");

  --*
  -- * 16-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16u_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:144
   pragma Import (C, nppiMalloc_16u_C1, "nppiMalloc_16u_C1");

  --*
  -- * 2 channel 16-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16u_C2
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:154
   pragma Import (C, nppiMalloc_16u_C2, "nppiMalloc_16u_C2");

  --*
  -- * 3 channel 16-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16u_C3
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:164
   pragma Import (C, nppiMalloc_16u_C3, "nppiMalloc_16u_C3");

  --*
  -- * 4 channel 16-bit unsigned image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16u_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16u;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:174
   pragma Import (C, nppiMalloc_16u_C4, "nppiMalloc_16u_C4");

  --*
  -- * 16-bit signed image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16s_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16s;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:184
   pragma Import (C, nppiMalloc_16s_C1, "nppiMalloc_16s_C1");

  --*
  -- * 2 channel 16-bit signed image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16s_C2
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16s;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:194
   pragma Import (C, nppiMalloc_16s_C2, "nppiMalloc_16s_C2");

  --*
  -- * 4 channel 16-bit signed image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16s_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16s;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:204
   pragma Import (C, nppiMalloc_16s_C4, "nppiMalloc_16s_C4");

  --*
  -- * 1 channel 16-bit signed complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16sc_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:214
   pragma Import (C, nppiMalloc_16sc_C1, "nppiMalloc_16sc_C1");

  --*
  -- * 2 channel 16-bit signed complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16sc_C2
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:224
   pragma Import (C, nppiMalloc_16sc_C2, "nppiMalloc_16sc_C2");

  --*
  -- * 3 channel 16-bit signed complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16sc_C3
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:234
   pragma Import (C, nppiMalloc_16sc_C3, "nppiMalloc_16sc_C3");

  --*
  -- * 4 channel 16-bit signed complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_16sc_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp16sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:244
   pragma Import (C, nppiMalloc_16sc_C4, "nppiMalloc_16sc_C4");

  --*
  -- * 32-bit signed image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32s_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32s;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:254
   pragma Import (C, nppiMalloc_32s_C1, "nppiMalloc_32s_C1");

  --*
  -- * 3 channel 32-bit signed image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32s_C3
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32s;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:264
   pragma Import (C, nppiMalloc_32s_C3, "nppiMalloc_32s_C3");

  --*
  -- * 4 channel 32-bit signed image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32s_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32s;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:274
   pragma Import (C, nppiMalloc_32s_C4, "nppiMalloc_32s_C4");

  --*
  -- * 32-bit integer complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32sc_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:284
   pragma Import (C, nppiMalloc_32sc_C1, "nppiMalloc_32sc_C1");

  --*
  -- * 2 channel 32-bit integer complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32sc_C2
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:294
   pragma Import (C, nppiMalloc_32sc_C2, "nppiMalloc_32sc_C2");

  --*
  -- * 3 channel 32-bit integer complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32sc_C3
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:304
   pragma Import (C, nppiMalloc_32sc_C3, "nppiMalloc_32sc_C3");

  --*
  -- * 4 channel 32-bit integer complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32sc_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32sc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:314
   pragma Import (C, nppiMalloc_32sc_C4, "nppiMalloc_32sc_C4");

  --*
  -- * 32-bit floating point image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32f_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32f;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:325
   pragma Import (C, nppiMalloc_32f_C1, "nppiMalloc_32f_C1");

  --*
  -- * 2 channel 32-bit floating point image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32f_C2
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32f;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:335
   pragma Import (C, nppiMalloc_32f_C2, "nppiMalloc_32f_C2");

  --*
  -- * 3 channel 32-bit floating point image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32f_C3
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32f;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:345
   pragma Import (C, nppiMalloc_32f_C3, "nppiMalloc_32f_C3");

  --*
  -- * 4 channel 32-bit floating point image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32f_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32f;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:355
   pragma Import (C, nppiMalloc_32f_C4, "nppiMalloc_32f_C4");

  --*
  -- * 32-bit float complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32fc_C1
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32fc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:365
   pragma Import (C, nppiMalloc_32fc_C1, "nppiMalloc_32fc_C1");

  --*
  -- * 2 channel 32-bit float complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32fc_C2
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32fc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:375
   pragma Import (C, nppiMalloc_32fc_C2, "nppiMalloc_32fc_C2");

  --*
  -- * 3 channel 32-bit float complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32fc_C3
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32fc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:385
   pragma Import (C, nppiMalloc_32fc_C3, "nppiMalloc_32fc_C3");

  --*
  -- * 4 channel 32-bit float complex image memory allocator.
  -- * \param nWidthPixels Image width.
  -- * \param nHeightPixels Image height.
  -- * \param pStepBytes \ref line_step.
  -- * \return Pointer to new image data.
  --  

   function nppiMalloc_32fc_C4
     (nWidthPixels : int;
      nHeightPixels : int;
      pStepBytes : access int) return access nppdefs_h.Npp32fc;  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:395
   pragma Import (C, nppiMalloc_32fc_C4, "nppiMalloc_32fc_C4");

  --* @} Malloc  
  --*
  -- * Free method for any 2D allocated memory.
  -- * This method should be used to free memory allocated with any of the nppiMalloc_<modifier> methods.
  -- * \param pData A pointer to memory allocated using nppiMalloc_<modifier>.
  --  

   procedure nppiFree (pData : System.Address);  -- /usr/local/cuda-8.0/include/nppi_support_functions.h:406
   pragma Import (C, nppiFree, "nppiFree");

  --* @} Image-Memory Management  
  -- extern "C"  
end nppi_support_functions_h;
