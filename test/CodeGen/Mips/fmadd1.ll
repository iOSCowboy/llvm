; Check that madd.[ds], msub.[ds], nmadd.[ds], and nmsub.[ds] are supported
; correctly.
; The spec for nmadd.[ds], and nmsub.[ds] does not state that they obey the
; the Has2008 and ABS2008 configuration bits which govern the conformance to
; IEEE 754 (1985) and IEEE 754 (2008). These instructions are therefore only
; available when -enable-no-nans-fp-math is given.

; RUN: llc < %s -march=mipsel -mcpu=mips32r2 -enable-no-nans-fp-math | FileCheck %s -check-prefix=32R2 -check-prefix=CHECK
; RUN: llc < %s -march=mips64el -mcpu=mips64r2 -mattr=n64 -enable-no-nans-fp-math | FileCheck %s -check-prefix=64R2 -check-prefix=CHECK
; RUN: llc < %s -march=mipsel -mcpu=mips32r2 | FileCheck %s -check-prefix=32R2NAN -check-prefix=CHECK
; RUN: llc < %s -march=mips64el -mcpu=mips64r2 -mattr=n64 | FileCheck %s -check-prefix=64R2NAN -check-prefix=CHECK

define float @FOO0float(float %a, float %b, float %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO0float:
; CHECK: madd.s 
  %mul = fmul float %a, %b
  %add = fadd float %mul, %c
  %add1 = fadd float %add, 0.000000e+00
  ret float %add1
}

define float @FOO1float(float %a, float %b, float %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO1float:
; CHECK: msub.s 
  %mul = fmul float %a, %b
  %sub = fsub float %mul, %c
  %add = fadd float %sub, 0.000000e+00
  ret float %add
}

define float @FOO2float(float %a, float %b, float %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO2float:
; 32R2: nmadd.s 
; 64R2: nmadd.s 
; 32R2NAN: madd.s 
; 64R2NAN: madd.s 
  %mul = fmul float %a, %b
  %add = fadd float %mul, %c
  %sub = fsub float 0.000000e+00, %add
  ret float %sub
}

define float @FOO3float(float %a, float %b, float %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO3float:
; 32R2: nmsub.s 
; 64R2: nmsub.s 
; 32R2NAN: msub.s 
; 64R2NAN: msub.s 
  %mul = fmul float %a, %b
  %sub = fsub float %mul, %c
  %sub1 = fsub float 0.000000e+00, %sub
  ret float %sub1
}

define double @FOO10double(double %a, double %b, double %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO10double:
; CHECK: madd.d
  %mul = fmul double %a, %b
  %add = fadd double %mul, %c
  %add1 = fadd double %add, 0.000000e+00
  ret double %add1
}

define double @FOO11double(double %a, double %b, double %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO11double:
; CHECK: msub.d
  %mul = fmul double %a, %b
  %sub = fsub double %mul, %c
  %add = fadd double %sub, 0.000000e+00
  ret double %add
}

define double @FOO12double(double %a, double %b, double %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO12double:
; 32R2: nmadd.d 
; 64R2: nmadd.d 
; 32R2NAN: madd.d 
; 64R2NAN: madd.d 
  %mul = fmul double %a, %b
  %add = fadd double %mul, %c
  %sub = fsub double 0.000000e+00, %add
  ret double %sub
}

define double @FOO13double(double %a, double %b, double %c) nounwind readnone {
entry:
; CHECK-LABEL: FOO13double:
; 32R2: nmsub.d 
; 64R2: nmsub.d 
; 32R2NAN: msub.d 
; 64R2NAN: msub.d 
  %mul = fmul double %a, %b
  %sub = fsub double %mul, %c
  %sub1 = fsub double 0.000000e+00, %sub
  ret double %sub1
}
