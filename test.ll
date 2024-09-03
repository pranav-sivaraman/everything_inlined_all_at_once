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
define noundef i32 @_Z8tail_fibiii(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #1 {
  br label %tailrecurse

tailrecurse:                                      ; preds = %4, %3
  %.tr = phi i32 [ %0, %3 ], [ %5, %4 ]
  %.tr10 = phi i32 [ %1, %3 ], [ %.tr11, %4 ]
  %.tr11 = phi i32 [ %2, %3 ], [ %6, %4 ]
  switch i32 %.tr, label %4 [
    i32 0, label %.loopexit.loopexit
    i32 1, label %.loopexit
  ]

4:                                                ; preds = %tailrecurse
  %5 = add nsw i32 %.tr, -1
  %6 = add nsw i32 %.tr11, %.tr10
  br label %tailrecurse

.loopexit.loopexit:                               ; preds = %tailrecurse
  br label %.loopexit

.loopexit:                                        ; preds = %tailrecurse, %.loopexit.loopexit
  %.0 = phi i32 [ %.tr10, %.loopexit.loopexit ], [ %.tr11, %tailrecurse ]
  ret i32 %.0
}

; Function Attrs: alwaysinline mustprogress nofree nounwind ssp memory(inaccessiblemem: readwrite) uwtable(sync)
define void @_Z3fooi(i32 noundef %0) local_unnamed_addr #2 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2)
  br label %tailrecurse.i

tailrecurse.i:                                    ; preds = %4, %1
  %.tr.i = phi i32 [ %0, %1 ], [ %5, %4 ]
  %.tr10.i = phi i32 [ 0, %1 ], [ %.tr11.i, %4 ]
  %.tr11.i = phi i32 [ 1, %1 ], [ %6, %4 ]
  switch i32 %.tr.i, label %4 [
    i32 0, label %_Z8tail_fibiii.exit
    i32 1, label %_Z8tail_fibiii.exit.loopexit
  ]

4:                                                ; preds = %tailrecurse.i
  %5 = add nsw i32 %.tr.i, -1
  %6 = add nsw i32 %.tr11.i, %.tr10.i
  br label %tailrecurse.i

_Z8tail_fibiii.exit.loopexit:                     ; preds = %tailrecurse.i
  br label %_Z8tail_fibiii.exit

_Z8tail_fibiii.exit:                              ; preds = %tailrecurse.i, %_Z8tail_fibiii.exit.loopexit
  %.0.i = phi i32 [ %.tr11.i, %_Z8tail_fibiii.exit.loopexit ], [ %.tr10.i, %tailrecurse.i ]
  store volatile i32 %.0.i, ptr %2, align 4, !tbaa !5
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3)
  %7 = tail call noundef i32 @_Z3fibi(i32 noundef %0)
  store volatile i32 %7, ptr %3, align 4, !tbaa !5
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2)
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #3

attributes #0 = { alwaysinline mustprogress nofree nosync nounwind ssp willreturn memory(none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { alwaysinline mustprogress nofree norecurse nosync nounwind ssp willreturn memory(none) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { alwaysinline mustprogress nofree nounwind ssp memory(inaccessiblemem: readwrite) uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 1}
!3 = !{i32 7, !"frame-pointer", i32 1}
!4 = !{!"Homebrew clang version 18.1.8"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
