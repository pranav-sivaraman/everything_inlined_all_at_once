#include "llvm/IR/PassManager.h"

namespace llvm {
class AnnotateAllAlwaysInline : public PassInfoMixin<AnnotateAllAlwaysInline> {
public:
  bool runOnModule(Module &M);

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &);
  static bool isRequired() { return true; };
};

} // namespace llvm
