---
layout: compsci-note
title: Sorting and Searching Algorithm Notes
categories: [fundamentals]
description: Some notes on sorting and searching algorithms, and time complexity
order: 20
sitemap: false
---

## Contents

* [Time complexity](#time-complexity)
* [Sorts](#sorts)
* [Searching](#searching)
  * [Uniformed searches](#uninformed-searches)
  * [Informed searches](#informed-searches)
  * [Heuristics](#heuristics)

## Definitions

Sorting:

* **In place**: `O(1)`, they do not need extra resources beyond the items that are given i.e. no new data structures.
* **Recursive**: can be both e.g. merge
* **Stability**: if duplicate values are kept in the *same* order after being sorted.
* **Adaptability**: if the input is partially sorted, it *affects* the running time.
* **Comparison**: it if only examines the data only by using a direct comparison symbol.

Searching:

* **Completeness**: does it always find a solution if one *exists?*
* **Time complexity**: number of nodes generated/expanded.
* **Space complexity**: *maximum* number of nodes in memory.
* **Optimality**: does it always find a least-cost solution?
* **Frontier**: nodes in queue to be explored.

## Time complexity

Useful links:

* [Easy mode intro](https://discrete.gr/complexity/)
* [Different complexities from Hackerrank](https://www.hackerearth.com/practice/basic-programming/complexity-analysis/time-and-space-complexity/tutorial/)
* [Graphs visualized](http://bigocheatsheet.com/) - this actually shows what **tight bound** means graphically!

We basically only care about O(n) since it is more practical and easier to calculate compared to Θ(n). Remember we only care about asymptotic behavior hence the removal of constants and only caring about the most dominant n.

|Asymptotic comparison operator| Explanation|
|------------------------------|--------------------------------------------------------------|
|`o(n)` - Small-O of n     | Asymptotic 'loose' upper bound - if we know a `O(n)` is **not** a tight bound, we can denote a `o(n)`|
|`O(n)` - Big-O of n       | Asymptotic upper bound - can't be worse than this but can be *better*|
|`Θ(n)` - Theta n          | Asymptotic tight bound - exactly the behavior (graph is between constants - see Hackerrank link)|
|`Ω(n)` - Big-Omega of n   | Asymptotic lower bound|
|`ω(n)` - Small-Omega of n | Asymptotic 'loose' lower bound - similar to small-o of n|

To determine if a bound is tight, we have to compare `O(n)` and `Θ(n)`. If `O(n)` > `Θ(n)`, then we say the **bound is not tight** and can generally speaking, replace `O(n)` with `o(n)`.

For example, we have Θ(n) and O(n<sup>2</sup>) for a given algorithm, we can determine that the bound is not tight and can denote o(n<sup>2</sup>).

### Big-O

* Represents the asymptotic **worst case** (unless stated otherwise) time complexity
* Big-O expressions do **not** have constants or low-order terms as when **n** gets larger these do not matter
  * i.e. 1.5n<sup>2</sup> + 3n + 10 = O(n<sup>2</sup>)
* **All** logarithmic function are in the same class **O(log(n))**
  * i.e. O(log<sub>2</sub>(n)) = O(log<sub>3</sub>(n)) as log<sub>b</sub>(a) * log<sub>a</sub>(n) = log<sub>b</sub>(n)

|Big-O      | Term | Explanation                                                                  |
|----------|------|-----------------------------------------------------------------------|
|O(1)      | Constant|Instructions in the program are executed a fixed number of times, **independent** of the `n` |
|O(log(n)) | Logarithmic| Some divide & conquer algorithms with trivial splitting and combining operations. e.g. binary search |
|O(n)      | Linear| Every element of the input has to be processed, usually in a straight forward way. e.g. linear search|
|O(nlog(n))| Logarithmic| Divide & conquer algorithms where splitting/combining operation is proportional to the input. <br> e.g. merge, heap, quick |
|O(n<sup>2</sup>)| Quadratic| Algorithms which have to compare each input value with every other input value. <br> e.g. bubble, insertion, selection |
|O(n<sup>3</sup>)| - |Only feasible for very small problem sizes |
|O(2<sup>n</sup>)| Exponential| Of almost no practical use|

Example of why time complexity matters:

|n   |log(n)| n*log(n) | n<sup>2</sup> | 2<sup>n</sup>  |
|--- |:-----|:---------|:--------------|:---------      |
|10  |   3  | 40       | 100           |1E+3            |
|100 |   7  | 700      | 10000         |1E+30           |
|1000|   10 | 10000    | 1000000       |1E+301          |

### Amortized complexity

Amortized analysis from [Wikipedia](https://en.wikipedia.org/wiki/Amortized_analysis)
> Amortized analysis considers both the costly and less costly operations together over the whole series of operations of the algorithm. This may include accounting for different types of input, length of the input, and other factors that affect its performance.
>
> The basic idea is that a **worst case** operation can alter the state in such a way that the worst case *cannot occur again for a long time*, thus "amortizing" its cost.
>
> There are generally three methods for performing amortized analysis: the **aggregate method**, the **accounting method**, and the **potential method**. All of these give correct answers; the choice of which to use depends on which is *most convenient* for a particular situation.
>
> **Aggregate** analysis determines the upper bound `T(n)` on the total cost of a sequence of n operations, then calculates the amortized cost to be `T(n) / n.`
>
> The **accounting** method is a form of aggregate analysis which *assigns* to each operation an amortized cost which may differ from its actual cost. Early operations have an amortized cost higher than their actual cost, which accumulates a saved "credit" that pays for later operations having an amortized cost lower than their actual cost.
> Because the credit begins at zero, the *actual cost of a sequence of operations equals the amortized cost minus the accumulated credit*. Because the credit is required to be *non-negative*, the amortized cost is an **upper bound on the actual cost**. Usually, many short-running operations accumulate such a credit in small increments, while rare long-running operations decrease it drastically.[4]
>
>The **potential** method is a form of the accounting method where the saved credit is computed as a function (the "potential") of the state of the data structure. The amortized cost is the immediate cost plus the change in potential.

## Sorts

* [Python implementation example](https://github.com/burrt/debian/blob/master/languages/python/sorts.py)

| Sort      | Complexity       | Features                                                         | Link                                                      | Description                                                                                                                                                                                                    |
|-----------|------------------|------------------------------------------------------------------|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Bubble    | O(n<sup>2</sup>) | * Comparison   <br> * Adaptive     <br> * Stable <br> * In-place | [Wikipedia](https://en.wikipedia.org/wiki/Bubble_sort)    | * Really simple, it just compares adjacent pairs in the array.<br>* Repeat this `n` times.                                                                                                                     |
| Insertion | O(n<sup>2</sup>) | * Adaptive     <br> * Stable       <br> * In-place               | [Wikipedia](https://en.wikipedia.org/wiki/Insertion_sort) | * Compares a value in the list iteratively and places it in order - compares values to its left.<br>* i.e. it will start at index 1, compare with index 0 - (swap)?, index 2 compares with 1..0 - (swap)? etc. |
| Selection | O(n<sup>2</sup>) | * Non-adaptive <br> * Stability depends   <br> * In-place        | [Wikipedia](https://en.wikipedia.org/wiki/Selection_sort) | * Keeps track of the current minimum index/value in the array.<br>* If the next values in the array are smaller, we swap - but only after traversing the RHS of the array.                                     |
| Merge     | O(nlog(n))       | * Non-adaptive <br> * Unstable   <br> * In-place                 |                                                           | * Splits the array into sub-arrays, then recursively sorts and merges the sub-arrays.                                                                                                                          |
| Heap      | O(nlog(n))       | * Non-adaptive <br> * Unstable   <br> * In-place                 |                                                           |                                                                                                                                                                                                                |
| Quick     | O(nlog(n))       | * Adaptive     <br> * Stability depends                          | [Wikipedia](https://en.wikipedia.org/wiki/Quicksort)      | * Makes use of pivots and applies divide and conquer strategy to sort.                                                                                                                                         |

### Quick sort

A few useful links:

* [Partition comparison](https://cs.stackexchange.com/questions/11458/quicksort-partitioning-hoare-vs-lomuto)

## Searching

Two different types:

* [Uninformed searches](#uninformed-searches) can only distinguish goal states from non-goal states.
* [Informed searches](#informed-searches) search strategies use heuristics to try to get 'closer' to the goal using a heuristic.

Time and space complexity are measured in terms of:

* `b` – maximum branching factor of the search tree
* `d` – depth of the least-cost/optimal/shallowest solution
* `m` – maximum depth of the state space (may be infinite)

## Uninformed searches

Examples:

* [Uniform Cost Search](#uniform-cost-search)
* [Breadth First Search](#breadth-first-search)
* [Depth First Search](#depth-first-search)
* [Depth Limited Search](#depth-first-search-limited)
* [Iterative Deepening Search](#iterative-deepening-search)

### Uniform Cost Search

* Takes into account of distances.
* Maintains a list of the **minimum** distance before the goal is reached.
* Once the queue of **un-discovered** nodes have been popped.
* C<sup>∗</sup> = cost of optimal solution.

| Attribute | Explanation                                                                                                                                                                           |
|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Complete  | Yes, if `b` is finite and step cost  for some                                                                                                                                         |
| Time      | O(b<sup>⌈C∗/e⌉</sup>) where , and assume every action costs at least `ε`                                                                                                                |
| Space     | O(b<sup>⌈C<sup>∗</sup>/e⌉</sup>) where b<sup>⌈C<sup>∗</sup>/e⌉</sup> = b<sup>d</sup> if **all step costs are equal**. <br> Or in other words, this reduces to BFS if paths are equal. |
| Optimal   | **Yes**, it will always find the shortest-distance path.                                                                                                                              |

### Breadth First Search

* Expand **all** nodes on the level **before* looking at the next level.
* It doesn't take into account of distances - it follows the shallowest node!

Difference with DFS:
> It checks whether a vertex has been discovered before enqueueing the vertex rather than delaying this check until the vertex is dequeued from the queue.

In order words, neighbour nodes can be added to the visited queue as well even it if hasn't been visited - this is actually an optimisation as it removes duplicated nodes on the unvisited fifo.

| Attribute  | Explanation                                                                                                                                    |
|------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| Complexity | **Yes**. The shallowest goal must be at some fixed depth `d` . It will be found before any deeper nodes are expanded (assuming `b` is finite). |
| Time       | **O(b<sup>d</sup>)**                                                                                                                           |
| Space      | **O(b<sup>d</sup>)**: keeps every node in memory; generate all nodes up to level `d`                                                           |
| Optimal    | **Yes**, but **only** if all actions have the same cost - so if you had weighted edges.                                                        |
| Other      | **Space** is the big problem for Breadth-First Search; it grows exponentially with **depth!**                                                  |

### Depth First Search

* It doesn't care about the optimal path - it traverses the tree to the deepest levels - this `m` could be infinite.
* Once a dead-end is reached, it returns and pops the next neighbour node at the `d-1`th level
* Stack based implementation.

Difference with BFS:
> It delays checking whether a vertex has been discovered until the vertex is popped from the stack rather than making this check before adding the vertex.

In other words, it cannot mark a node as visited like in BFS until it has been popped off the stack.

| Attribute | Explanation                                                                                                                          |
|-----------|--------------------------------------------------------------------------------------------------------------------------------------|
| Complete  | **No!** Fails in infinite depth spaces, spaces with loops; modify to avoid repeated by keeping track of visited states.              |
| Time      | **O(b<sup>m</sup>)** - terrible if `m` is much larger than `d` but if solutions are **dense**, may be much faster than breadth-first |
| Space     | **O(bm)**, i.e. linear space!                                                                                                        |
| Optimal   | **No**, can find sub-optimal solutions first                                                                                         |

### Depth First Search (limited)

* Expands nodes like Depth First Search but imposes a cutoff on the maximum depth of path - `k`.
* How to pick a good limit?

| Attribute | Explanation                                                                    |
|-----------|--------------------------------------------------------------------------------|
| Complete  | **Yes** - no infinite loops anymore, don't need to keep track of visited nodes |
| Time      | **O(b<sup>k</sup>)** where `k` is the depth limit                              |
| Space     | **O(bk)** i.e. linear space similar to DFS                                     |
| Optimal   | **No**, can find sub optimal solutions first                                   |

### Iterative Deepening Search

* Problem with Limited DFS: what if **solution** is deeper than `k`? - increase `k` iteratively.
* Summary:
  * Start with `k=1` - we get the root node, it is not the goal
  * Restart search with `k=2` i.e. maximum depth, so assume `b=2`, 3 nodes expanded.
  * Restart search with `k=3` and so on until we reach the goal node.
  * The idea is that you **will** repeat already expanded nodes e.g. the root node - assuming it's not the goal.
  * This incurs a little overhead but you eliminate the non-completeness. It also combines some of the benefits of BFS and DFS.

## Informed searches

* [Greedy search](#greedy-search)
* [A* search](#a-search)
* [Iterative Deepening A* Search](#iterative-deepening-a-search)
* [Alpha Beta search](#alpha-beta-search) - an optimisation

### Greedy Search

* Computes the path based **only** on the heuristic e.g. the straight line distance.
* It is an informed search but is greedy!
* It almost functions like UCS but uses a heuristic instead.

| Attribute | Explanation                                            |
|-----------|--------------------------------------------------------|
| Complete  | **No** - like DFS, need to keep track of visited nodes |
| Time      | **O(b<sup>m</sup>)**                                   |
| Space     | **O(b<sup>m</sup>)** i.e. linear space similar to DFS  |
| Optimal   | **No**, greedy for a reason                            |

### A* Search

* It is optimal if heuristic is admissible.
* This falls back to UCS (Dijkstra's algorithm) if `h(n) = 0`.
* It uses the following: `f(n) = g(n) + h(n)` where:
  * `g(n)` is the distance
  * `h(n)` is the heuristic e.g. the straight line distance from the the **current node** to the **goal**
* Space or memory can be an issue.
* There are other `h(n)` to use to make it more optimal e.g. Manhattan, Misplaced, Euclidean.

| Attribute | Explanation                                                                |
|-----------|----------------------------------------------------------------------------|
| Complete  | Yes – unless there are infinitely many nodes with **f(n) ≤ C<sup>*</sup>** |
| Time      | Number of nodes for which **f(n) ≤ C<sup>*</sup>** (exponential)           |
| Space     | O(b<sup>d</sup>)                                                           |
| Optimal   | Yes - assuming `h(n)` is admissible                                        |

### Iterative Deepening A* Search

* A *low memory* variant of A* - nodes are still expanded with `f(n) = g(n) + h(n)`
* This function will be limited to a certain **cut-off/threshold**
  * This threshold - like IDS, increases iteratively.
* IDA* is asymptotically as efficient as A* for domains where the number of states grows exponentially.

| Attribute | Explanation                                                                |
|-----------|----------------------------------------------------------------------------|
| Complete  | **Yes** – unless there are infinitely many nodes with f(n) ≤ C<sup>*</sup> |
| Time      | Number of nodes for which f(n) ≤ C<sup>*</sup> (exponential)               |
| Space     | Exponential - keeps all nodes is memory                                    |
| Optimal   | **Yes** - assuming `h(n)` is admissible                                    |

### Alpha-Beta search

I actually think this algorithm is magic - it's so awesome!

* Is used for game playing e.g. determining the next best move for Minmax.
* Note that this isn't a *replacement* for a search algorithm but rather an optimisation for an *existing* one.
* Instead of traversing all decisions of a Minmax **O(b<sup>d</sup>)**, alpha-beta effectively prunes unnecessary decisions from the search by 'intuition'.

Basic steps:

* Each level alternate between MIN/MAX.
* Do a depth first traversal until you hit the leaves.
* Recursively traverse the tree and return the values up to the upper level.
* Depending on the previous *alpha* and *beta* values - we can skip a whole subtree.

## Heuristics

Some of them include:

* Straight line distance
* Manhattan
* Diagonal
* Euclidean
* Breaking ties

I think the [Standford website](http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html) summarises heuristics far better than I can.

### Straight line distance

```c
D = sqrt((x1 - x2)**2 + (y1 - y2)**2)
```

### Manhattan

For your typical 4 move heuristic (N, S, E, W). Check out this excellent [Standford website]( http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html).

```python
function heuristic(node) =
    dx = abs(node.x - goal.x)
    dy = abs(node.y - goal.y)
    return D * (dx + dy)
```

### Breaking ties

Basically when the search needs to decide upon two or more paths to search but they are both **equal** cost, we can introduce a bias in the path cost algorithm. This may break a heuristic being admissible - read the link for further explanation.
