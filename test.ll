; ModuleID = 'test.ll'
source_filename = "test.cpp"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

; Function Attrs: alwaysinline mustprogress nofree nosync nounwind ssp willreturn memory(none) uwtable(sync)
define noundef i32 @_Z3fibi(i32 noundef %0) local_unnamed_addr #0 {
  %or.cond8 = icmp ult i32 %0, 2
  br i1 %or.cond8, label %tailrecurse._crit_edge, label %tailrecurse

tailrecurse:                                      ; preds = %1, %tailrecurse
  %.tr10 = phi i32 [ %4, %tailrecurse ], [ %0, %1 ]
  %accumulator.tr9 = phi i32 [ %5, %tailrecurse ], [ 0, %1 ]
  %2 = add nsw i32 %.tr10, -1
  %3 = tail call noundef i32 @_Z3fibi(i32 noundef %2)
  %4 = add nsw i32 %.tr10, -2
  %5 = add nsw i32 %3, %accumulator.tr9
  %or.cond = icmp ult i32 %4, 2
  br i1 %or.cond, label %tailrecurse._crit_edge, label %tailrecurse

tailrecurse._crit_edge:                           ; preds = %tailrecurse, %1
  %accumulator.tr.lcssa = phi i32 [ 0, %1 ], [ %5, %tailrecurse ]
  %.tr.lcssa = phi i32 [ %0, %1 ], [ %4, %tailrecurse ]
  %accumulator.ret.tr = add nsw i32 %.tr.lcssa, %accumulator.tr.lcssa
  ret i32 %accumulator.ret.tr
}

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync)
define noundef i32 @_Z8tail_fibii(i32 noundef %0, i32 noundef %1) local_unnamed_addr #1 {
  %or.cond10 = icmp ult i32 %0, 2
  br i1 %or.cond10, label %tailrecurse._crit_edge, label %tailrecurse.preheader

tailrecurse.preheader:                            ; preds = %2
  %3 = add i32 %0, -1
  %min.iters.check = icmp ult i32 %0, 17
  br i1 %min.iters.check, label %tailrecurse.preheader21, label %vector.ph

vector.ph:                                        ; preds = %tailrecurse.preheader
  %n.vec = and i32 %3, -16
  %ind.end = sub i32 %0, %n.vec
  %4 = insertelement <4 x i32> <i32 poison, i32 1, i32 1, i32 1>, i32 %1, i64 0
  %.splatinsert = insertelement <4 x i32> poison, i32 %0, i64 0
  %.splat = shufflevector <4 x i32> %.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  %induction = add <4 x i32> %.splat, <i32 0, i32 -1, i32 -2, i32 -3>
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ %4, %vector.ph ], [ %5, %vector.body ]
  %vec.phi13 = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ %6, %vector.body ]
  %vec.phi14 = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ %7, %vector.body ]
  %vec.phi15 = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ %8, %vector.body ]
  %vec.ind = phi <4 x i32> [ %induction, %vector.ph ], [ %vec.ind.next, %vector.body ]
  %step.add = add <4 x i32> %vec.ind, <i32 -4, i32 -4, i32 -4, i32 -4>
  %step.add16 = add <4 x i32> %vec.ind, <i32 -8, i32 -8, i32 -8, i32 -8>
  %step.add17 = add <4 x i32> %vec.ind, <i32 -12, i32 -12, i32 -12, i32 -12>
  %5 = mul <4 x i32> %vec.phi, %vec.ind
  %6 = mul <4 x i32> %vec.phi13, %step.add
  %7 = mul <4 x i32> %vec.phi14, %step.add16
  %8 = mul <4 x i32> %vec.phi15, %step.add17
  %index.next = add nuw i32 %index, 16
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 -16, i32 -16, i32 -16, i32 -16>
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !5

middle.block:                                     ; preds = %vector.body
  %bin.rdx = mul <4 x i32> %6, %5
  %bin.rdx19 = mul <4 x i32> %7, %bin.rdx
  %bin.rdx20 = mul <4 x i32> %8, %bin.rdx19
  %10 = tail call i32 @llvm.vector.reduce.mul.v4i32(<4 x i32> %bin.rdx20)
  %cmp.n = icmp eq i32 %3, %n.vec
  br i1 %cmp.n, label %tailrecurse._crit_edge, label %tailrecurse.preheader21

tailrecurse.preheader21:                          ; preds = %tailrecurse.preheader, %middle.block
  %.tr912.ph = phi i32 [ %1, %tailrecurse.preheader ], [ %10, %middle.block ]
  %.tr11.ph = phi i32 [ %0, %tailrecurse.preheader ], [ %ind.end, %middle.block ]
  br label %tailrecurse

tailrecurse:                                      ; preds = %tailrecurse.preheader21, %tailrecurse
  %.tr912 = phi i32 [ %12, %tailrecurse ], [ %.tr912.ph, %tailrecurse.preheader21 ]
  %.tr11 = phi i32 [ %11, %tailrecurse ], [ %.tr11.ph, %tailrecurse.preheader21 ]
  %11 = add nsw i32 %.tr11, -1
  %12 = mul nsw i32 %.tr912, %.tr11
  %or.cond = icmp ult i32 %.tr11, 3
  br i1 %or.cond, label %tailrecurse._crit_edge, label %tailrecurse, !llvm.loop !8

tailrecurse._crit_edge:                           ; preds = %tailrecurse, %middle.block, %2
  %.tr9.lcssa = phi i32 [ %1, %2 ], [ %10, %middle.block ], [ %12, %tailrecurse ]
  ret i32 %.tr9.lcssa
}

; Function Attrs: alwaysinline mustprogress nofree nounwind ssp memory(inaccessiblemem: readwrite) uwtable(sync)
define void @_Z3fooi(i32 noundef %0) local_unnamed_addr #2 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2)
  %or.cond10.i = icmp ult i32 %0, 2
  br i1 %or.cond10.i, label %_Z8tail_fibii.exit, label %tailrecurse.i.preheader

tailrecurse.i.preheader:                          ; preds = %1
  %4 = add i32 %0, -1
  %min.iters.check = icmp ult i32 %0, 17
  br i1 %min.iters.check, label %tailrecurse.i.preheader10, label %vector.ph

vector.ph:                                        ; preds = %tailrecurse.i.preheader
  %n.vec = and i32 %4, -16
  %ind.end = sub i32 %0, %n.vec
  %.splatinsert = insertelement <4 x i32> poison, i32 %0, i64 0
  %.splat = shufflevector <4 x i32> %.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  %induction = add <4 x i32> %.splat, <i32 0, i32 -1, i32 -2, i32 -3>
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ %5, %vector.body ]
  %vec.phi2 = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ %6, %vector.body ]
  %vec.phi3 = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ %7, %vector.body ]
  %vec.phi4 = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ %8, %vector.body ]
  %vec.ind = phi <4 x i32> [ %induction, %vector.ph ], [ %vec.ind.next, %vector.body ]
  %step.add = add <4 x i32> %vec.ind, <i32 -4, i32 -4, i32 -4, i32 -4>
  %step.add5 = add <4 x i32> %vec.ind, <i32 -8, i32 -8, i32 -8, i32 -8>
  %step.add6 = add <4 x i32> %vec.ind, <i32 -12, i32 -12, i32 -12, i32 -12>
  %5 = mul <4 x i32> %vec.ind, %vec.phi
  %6 = mul <4 x i32> %step.add, %vec.phi2
  %7 = mul <4 x i32> %step.add5, %vec.phi3
  %8 = mul <4 x i32> %step.add6, %vec.phi4
  %index.next = add nuw i32 %index, 16
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 -16, i32 -16, i32 -16, i32 -16>
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !9

middle.block:                                     ; preds = %vector.body
  %bin.rdx = mul <4 x i32> %6, %5
  %bin.rdx8 = mul <4 x i32> %7, %bin.rdx
  %bin.rdx9 = mul <4 x i32> %8, %bin.rdx8
  %10 = tail call i32 @llvm.vector.reduce.mul.v4i32(<4 x i32> %bin.rdx9)
  %cmp.n = icmp eq i32 %4, %n.vec
  br i1 %cmp.n, label %_Z8tail_fibii.exit, label %tailrecurse.i.preheader10

tailrecurse.i.preheader10:                        ; preds = %tailrecurse.i.preheader, %middle.block
  %.tr912.i.ph = phi i32 [ 1, %tailrecurse.i.preheader ], [ %10, %middle.block ]
  %.tr11.i.ph = phi i32 [ %0, %tailrecurse.i.preheader ], [ %ind.end, %middle.block ]
  br label %tailrecurse.i

tailrecurse.i:                                    ; preds = %tailrecurse.i.preheader10, %tailrecurse.i
  %.tr912.i = phi i32 [ %12, %tailrecurse.i ], [ %.tr912.i.ph, %tailrecurse.i.preheader10 ]
  %.tr11.i = phi i32 [ %11, %tailrecurse.i ], [ %.tr11.i.ph, %tailrecurse.i.preheader10 ]
  %11 = add nsw i32 %.tr11.i, -1
  %12 = mul nsw i32 %.tr11.i, %.tr912.i
  %or.cond.i = icmp ult i32 %.tr11.i, 3
  br i1 %or.cond.i, label %_Z8tail_fibii.exit, label %tailrecurse.i, !llvm.loop !10

_Z8tail_fibii.exit:                               ; preds = %tailrecurse.i, %middle.block, %1
  %.tr9.lcssa.i = phi i32 [ 1, %1 ], [ %10, %middle.block ], [ %12, %tailrecurse.i ]
  store volatile i32 %.tr9.lcssa.i, ptr %2, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3)
  %13 = tail call noundef i32 @_Z3fibi(i32 noundef %0)
  store volatile i32 %13, ptr %3, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2)
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.vector.reduce.mul.v4i32(<4 x i32>) #4

attributes #0 = { alwaysinline mustprogress nofree nosync nounwind ssp willreturn memory(none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { alwaysinline mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { alwaysinline mustprogress nofree nounwind ssp memory(inaccessiblemem: readwrite) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 1}
!3 = !{i32 7, !"frame-pointer", i32 1}
!4 = !{!"Homebrew clang version 18.1.8"}
!5 = distinct !{!5, !6, !7}
!6 = !{!"llvm.loop.isvectorized", i32 1}
!7 = !{!"llvm.loop.unroll.runtime.disable"}
!8 = distinct !{!8, !7, !6}
!9 = distinct !{!9, !6, !7}
!10 = distinct !{!10, !7, !6}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !13, i64 0}
!13 = !{!"omnipotent char", !14, i64 0}
!14 = !{!"Simple C++ TBAA"}
