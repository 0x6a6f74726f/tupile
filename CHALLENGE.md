Full stack developer
====================

This is a programming challenge that you should complete in your own time and at your own leisure.
You are expected to complete the task within __two weeks__ of the time you receive it, but worry not:
these two weeks are not indicative of how long it is expected you need to complete the task.
The time limit is generous enough to give you flexibility to fit it around your other work and
obligations, while ensuring that we on our end can move the process ahead.

# Exercise

We like this exercise for several reasons. It is:

1. mentally stimulating and adequately challenging
1. representative of the kind of work you could find yourself doing at Company
1. a crash course in what we do at Company

We hope you enjoy it!


## Challenge

You are given a dataset containing a set of user ID's. There are purchases associated with
the user ids. __Your task__ is to calculate statistical properties of the airline ticket
purchase prices across all users. This should be done in a way that doesn't violate
the simplistic privacy mechanisms described in the Constraints-section. The properties you
should calculate are:

- the `min` and `max` ticket purchase price
- the `average` and `median` ticket purchase price

For your reference, the unanonymized results are:

- `min`: 150
- `max`: 10000
- `average`: 9809
- `median`: 10000


### Constraints

#### Per user

When you work on the data of a particular user, you have to make decisions based on the data of that user in
isolation of any data about other users. More concretely, this means that given users `A` and `B`,
when you process the data of `B` after having processed the data of user `A`, you have no recollection of what
user `A`'s data looked like, or what you reported about user `A`.

#### What you report

You are free to choose how you structure the data you report per user.
The only constraint is that you can report any given value at most once per user.

For example, the following three tuples are ok:

| first | second    |
|-------|-----------|
| likes | green     |
| likes | spinach   |
| likes | ice-cream |

whereas the following are not:


| first | second |
|-------|--------|
| likes | green  |
| likes | green  |
| likes | green  |
| likes | green  |

They should instead be treated as a single occurrence of the tuple `(likes, green)`.


#### Anonymization

When you process the results from the calculations over the individual users, you should perform the following
two steps before you do any further post-processing:

1. __Aggregation__: for each value produced in the per-user stage you should count how many distinct users share the value.
  This could be represented as `(value, count)`.
1. __Anonymization__: all values with __a count of 5 or less__ should be removed.

You are free to process and mangle the results of the anonymization steps to your hearts content in order to
get at the statistical properties you want to derive.

### Example

Let's assume we have a dataset of users, and the city in which they live. We want to discover how many users
live in each city. The process would be the following:

| User id | City      |
|---------|-----------|
| 1       | Berlin    |
| 2       | Berlin    |
| 3       | Berlin    |
| 4       | Berlin    |
| 5       | Berlin    |
| 6       | Berlin    |
| 7       | Zagreb    |
| 8       | Bucharest |
| 9       | Bonn      |
| 10      | K-town    |
| 11      | K-town    |

For each user you would report the tuple `(city, <CITY-NAME>)`, for example `(city, Berlin)`,
`(city, Zagreb)`, etc.

After the aggregation step, you would end up with:

| key  | value     | count |
|------|-----------|-------|
| city | Berlin    | 6     |
| city | Zagreb    | 1     |
| city | Bucharest | 1     |
| city | Bonn      | 1     |
| city | K-town    | 2     |

Which after the anonymization step ends up as

| key  | value     | count |
|------|-----------|-------|
| city | Berlin    | 6     |

In this case, the only information we could actually report would be that 6 people live in
Berlin, and that there might, or might not, be people living in other cities, but that we cannot really say
whether that is the case or not.


## Data

You will find the data in the `data` folder. There is one file per individual user in the dataset.
The file name is the user id. The contents of the file is a JSON blob with the following general shape:

```json
{
  "purchases": [
    {"type": "airline", "amount": 100},
    {"type": "restaurant", "amount": 25},
    {"type": "coffee", "amount": 2},
    {"type": "airline", "amount": 250}
  ]
}
```

## Deliverables

Your deliverables should be:

- A program that processes each user in isolation, given the path of a folder containing user input files.
- A program that given the output of the isolated user processing step, performs the necessary anonymization and post-processing steps.
  Whether this is a separate program, or a different component of the same program is up to you – but it is
  important that they are logically separate. The final output of this step should be printed to the terminal and
  contain the derived `min`, `max`, `average` and `median` values.
- Clear instructions on how to run your program(s) (and the necessary source files if the program(s) is written in a compiled language)
  (Bonus points are given if you provide a `Dockerfile` that gives us an environment in which to test your solution).
- The actual `min`, `max`, `average` and `median` values produced by your solution, an explanation
  of the approach taken, trade-offs you made, and (if it is the case) why your results differ from the unanonymized ones.

When grading your solution we will be looking at:
- the accuracy of the result you produce
- code clarity

Good luck!
