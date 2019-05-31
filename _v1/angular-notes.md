---
layout: compsci-note
title: Angular Notes
categories: [web-dev]
description: Some basic notes on Angular
order: 20
sitemap: false
---

## Angular

## Features

```html
<div *ngFor="let user of users"/>

<!-- Comments out or not render the div if null or false -->
<div *ngIf="users?.Name"/>

<!-- Will still render but not show - useful if it will be reused -->
<div [Hidden]="true"/>

<!-- Switch statement for ngIf -->
<div [*ngSwitch]="fruitlist">
    <span *ngSwitchCase="'apple'"></span>
    <span *ngSwitchCase="'orange'"></span>
    <span *ngSwitchDefault>Default case</span>
</div>

<!--
    Apply classes to an element
    For class bindings, you'll need to create the style and is limited to only one
    For ngClass, you can specify an object dictionary, array or string of classes and can apply many
      - you can also call a class method which can have more complex code

-->
<div class="well" [class.green]="user?.name === 'bob'" [ngClass]="{green: event?.time === '8:00 am', bold: event?.time === '9:00 am'}"/>

```

```ts
export class SomeComponent{
    getStartTimeStyleForNgClass()
    {
        const isEarlyStart = this.event?.time === '8:00 am' && this.event?.time === '10:00 am');
        return {green: isEarlyStart, bold: isEarlyStart}
        }
    }

    getStartTimeStyleForNgStyle() : any
    {
        if (isEarlyStart = this.event?.time === '8:00 am' && this.event?.time === '10:00 am') {
            return {color: green, 'font-weight': 'bold'}
        }
    }
}
```
