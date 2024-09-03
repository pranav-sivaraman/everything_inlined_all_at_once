
/* TODO: Potential invalid cases
 * - Polymorphic type function calls.
 * - Recursion
 * - Tail Recursion (need to see what happens)
 * - Multiple Return Statements?
 */

// Huh. this just gets optimized into the tail call?
// which then does not get inlined
int fib(int x) {
  if (x == 0 || x == 1) {
    return x;
  }

  return fib(x - 1) + fib(x - 2);
}

// This function gets inlined
int tail_fib(int x, int acc = 1) {
  if (x == 0 || x == 1) {
    return acc;
  }
  return tail_fib(x - 1, acc * x);
}

void foo(int N) {
  // SANITY CHECK: Order of function calls do not matter.
  volatile int y = tail_fib(N);
  volatile int x = fib(N);
}
