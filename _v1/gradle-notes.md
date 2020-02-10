---
layout: compsci-note
title: Gradle Notes
categories: [tools]
description: Some notes on Gradle
order: 20
sitemap: false
---

## Gradle

Gradle is a build automation tool.

## Tasks

Gradle achieves its operations through tasks which are defined in the `build.gradle` file which is extended with plugins. To define custom tasks and run them with `./gradlew someTask`:

```groovy
task someTask {
    println "Some custom task"
}
```

## Build phases

A task has different phases in its execution:

1. Initialization phase
    * Used to configure multi-project builds
2. Configuration phase
    * Executes code in tasks that's not the action e.g. description
3. Execution phase
    * Execute task actions

### Variables

You can define local variables within tasks or share it between tasks with `def someVar`. To share variables outside the script, use `ext someGlobalVar`.

### Dependencies

Tasks can depend on each other and there are a few ways of achieving this:

1. `dependsOn` - will be run after task T, doesn't handle circular dependencies
2. `mustRunAfter` - will detect and fail on circular dependencies
3. `shouldRunAfter` - doesn't handle circular dependencies
4. `finalizedBy` - invered dependency

Order of concurrent task execution is random.

### Extending tasks

A common use case is to copy certain files and leverage the Gradle plugin `Copy`:

```groovy
// You can filter certain files etc. by setting the relevant properties
task copyStuff (type: Copy) {
    into 'dst'
}
```

