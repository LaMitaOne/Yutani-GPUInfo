# Yutani-GPUInfo v1.0
A lightweight, single-file Delphi unit for universal hardware-based GPU capability, VRAM, and compute shader speed detection — with **zero external dependencies**.
    
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/LaMitaOne/Yutani-GPUInfo)    
          
<img height="400" alt="Unbenannt" src="https://github.com/user-attachments/assets/e5b452e6-fd39-42ca-ae82-d0b1212f6771" />
    
Instead of relying on fragile GPU name blacklists or whitelists, it queries actual hardware limits, memory availability, and real-world compute shader throughput across NVIDIA, AMD, Intel (HD / Iris / Arc), and exotic or virtualized GPUs.    
     
## Features
- **Single-file drop-in unit:** Just add `Yutani.GPUInfo.pas` to your `uses` clause—no third-party libraries, headers, or DLL wrappers required.
- **Vendor-agnostic VRAM detection:** Combines Windows DXGI (`dxgi.dll`) adapter enumeration (`DedicatedVideoMemory` & `SharedSystemMemory`) with OpenGL extensions (`GL_NVX_gpu_memory_info` & `GL_ATI_meminfo`).     
- **OpenGL 4.3+ feature & limit queries:** Checks Compute Shaders, SSBOs, `imageLoad`/`imageStore`, Bindless Textures, max workgroup counts, and max SSBO sizes.
- **15ms live compute micro-benchmark:** Runs a quick 262K-element SSBO compute pass to measure real GPU memory bandwidth and ALU throughput (`ComputeScore`).
- **Automatic hardware tiering:** Classifies the GPU into `gtFallback`, `gtLowIGPU`, `gtMidIGPU`, or `gtDedicatedGPU` and provides ready-to-use workload budgets.
     
## Quick Usage
*(Requires an active OpenGL context)*
     
```pascal
uses
  Yutani.GPUInfo;

var
  Caps: TGPUCapabilities;
begin
  Caps := DetectGPUCapabilities(True); // True = include ~15ms live compute benchmark
  Memo1.Lines.Text := FormatGPUReport(Caps);
end;
```
      
## Example Output (Ryzen 4500U / Vega 6 iGPU)
     
```text
=== Yutani Universal GPU Report ===
Vendor:          ATI Technologies Inc.
Renderer:        AMD Radeon(TM) Graphics
OpenGL / GLSL:   4.6.0 Compatibility Profile Context (v4.6) | 4.60
-----------------------------------
Compute Shader:  YES
SSBO Support:    YES
ImageLoadStore:  YES
Bindless Tex:    YES
-----------------------------------
Dedicated VRAM:  495 MB (Dedicated Hardware: NO)
Shared Sys-RAM:  3600 MB
Free VRAM (GL):  495 MB
WorkGroups Max:  2147483647 x 65535 x 65535
Max SSBO Size:   2047 MB
15ms GPU Bench:  3.34 ms (Compute Score: 299)
-----------------------------------
Detected Tier:   Modern iGPU / UMA (Balanced)
Auto-Budget:     1500000 Particles | 500000 Grass Blades
===================================
```    
     
## Included in this Repository    
- `Yutani.GPUInfo.pas` — Standalone detection unit     
- VCL sample project + precompiled `.exe` to test your GPU right away     
       
Part of Yutani https://github.com/LaMitaOne/Yutani-Building-better-worlds    
