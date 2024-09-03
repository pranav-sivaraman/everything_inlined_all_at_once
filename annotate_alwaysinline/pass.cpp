#include "pass.h"

#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

namespace llvm {
bool AnnotateAllAlwaysInline::runOnModule(Module &M) {
  bool changed = false;

  for (auto &F : M) {
    if (F.hasFnAttribute(Attribute::AlwaysInline))
      continue;

    F.addFnAttr(Attribute::AlwaysInline);
    changed = true;
  }

  return changed;
}

PreservedAnalyses AnnotateAllAlwaysInline::run(Module &M,
                                               ModuleAnalysisManager &) {
  bool Changed = runOnModule(M);

  return (Changed ? PreservedAnalyses::none() : PreservedAnalyses::all());
}

PassPluginLibraryInfo getAnnotateAllAlwaysInlineInfo() {
  return {LLVM_PLUGIN_API_VERSION, "AnnotateAllAlwaysInline",
          LLVM_VERSION_STRING, [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "annotate-all-always-inline") {
                    MPM.addPass(AnnotateAllAlwaysInline());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getAnnotateAllAlwaysInlineInfo();
}

} // namespace llvm
