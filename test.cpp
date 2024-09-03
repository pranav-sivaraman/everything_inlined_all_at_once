
/* TODO: Potential invalid cases
 * - Polymorphic type function calls.
 * - Recursion
 * - Tail Recursion (need to see what happens)
 * - Multiple Return Statements?
 */

// Huh. this just gets optimized into a tail call?
// which then does not get inlined. Is there a specific
// pass for fibonacci?
int fib(int x) {
  if (x == 0 || x == 1) {
    return x;
  }

  return fib(x - 1) + fib(x - 2);
}

// This function gets inlined
// I guess there is pass that converts this to a loop? Looking at the IR
// there is.
int tail_fib(int x, int a = 0, int b = 1) {
  if (x == 0) {
    return a;
  }

  if (x == 1) {
    return b;
  }

  return tail_fib(x - 1, b, a + b);
}

void foo(int N) {
  // SANITY CHECK: Order of function calls do not matter.
  volatile int y = tail_fib(N);
  volatile int x = fib(N);
}
