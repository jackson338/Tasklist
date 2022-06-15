import 'package:flutter/material.dart';

class HintPopUps extends StatelessWidget {
  const HintPopUps({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Home Page'),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        Text(
          'Welcome to the Home Page! This is where you\'ll see a chart for the percentage of daily tasks you\'ve completed this week.',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            'You will also be able to navigate to your Calendar, Daily Task, Journal, and Statistics pages!',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).dividerColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Dismiss',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).dividerColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Adding Tasks'),
                        backgroundColor: Theme.of(context).backgroundColor,
                        actions: [
                          Text(
                            'Hit the \"+\" button to add a new:',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Calendar Task',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Today Task',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Daily Task',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Goal Task',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Theme.of(context).dividerColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Dismiss',
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Theme.of(context).dividerColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Calendar Tasks'),
                                                backgroundColor:
                                                    Theme.of(context).backgroundColor,
                                                actions: [
                                                  Text(
                                                    'Calendar tasks add to your today list automatically on their set date.',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    Theme.of(context)
                                                                        .dividerColor),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text(
                                                            'Dismiss',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    Theme.of(context)
                                                                        .dividerColor),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            showDialog(
                                                              barrierDismissible: true,
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      Text('Today Task'),
                                                                  backgroundColor: Theme
                                                                          .of(context)
                                                                      .backgroundColor,
                                                                  actions: [
                                                                    Text(
                                                                      'Today Tasks add to your Today List. They will stay there until completed or deleted. You shouldn\'t have a today task for more than a couple days. ',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets
                                                                                      .all(
                                                                                  8.0),
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor:
                                                                                  MaterialStateProperty.all(
                                                                                      Theme.of(context).dividerColor),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(
                                                                                      context)
                                                                                  .pop();
                                                                            },
                                                                            child: Text(
                                                                              'Dismiss',
                                                                              style: Theme.of(
                                                                                      context)
                                                                                  .textTheme
                                                                                  .bodyText1,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets
                                                                                      .all(
                                                                                  8.0),
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor:
                                                                                  MaterialStateProperty.all(
                                                                                      Theme.of(context).dividerColor),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(
                                                                                      context)
                                                                                  .pop();
                                                                              showDialog(
                                                                                barrierDismissible:
                                                                                    true,
                                                                                context:
                                                                                    context,
                                                                                builder:
                                                                                    (context) {
                                                                                  return AlertDialog(
                                                                                    title:
                                                                                        Text('Daily Task'),
                                                                                    backgroundColor:
                                                                                        Theme.of(context).backgroundColor,
                                                                                    actions: [
                                                                                      Text(
                                                                                        'Daily Tasks will add to your Daily Today list. These will repeat every day. Use these to set a routine.',
                                                                                        style: Theme.of(context).textTheme.bodyText1,
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: ElevatedButton(
                                                                                              style: ButtonStyle(
                                                                                                backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                              child: Text(
                                                                                                'Dismiss',
                                                                                                style: Theme.of(context).textTheme.bodyText1,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: ElevatedButton(
                                                                                              style: ButtonStyle(
                                                                                                backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                                showDialog(
                                                                                                  barrierDismissible: true,
                                                                                                  context: context,
                                                                                                  builder: (context) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text('Goal Task'),
                                                                                                      backgroundColor: Theme.of(context).backgroundColor,
                                                                                                      actions: [
                                                                                                        Text(
                                                                                                          'Goal tasks add to your Goals list. You can go into a Goal Task and add sub-goals through the list icon on the right. You can add and track an infinite amount of sub goals! Use these to help you achieve your goals. To delete a goal or sub goal with all of it\'s sub goals hit the delete icon in the top right of the expanded goal page.',
                                                                                                          style: Theme.of(context).textTheme.bodyText1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                                              child: ElevatedButton(
                                                                                                                style: ButtonStyle(
                                                                                                                  backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                                                ),
                                                                                                                onPressed: () {
                                                                                                                  Navigator.of(context).pop();
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                  'Dismiss',
                                                                                                                  style: Theme.of(context).textTheme.bodyText1,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                                              child: ElevatedButton(
                                                                                                                style: ButtonStyle(
                                                                                                                  backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                                                ),
                                                                                                                onPressed: () {
                                                                                                                  Navigator.of(context).pop();
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                  'Done',
                                                                                                                  style: Theme.of(context).textTheme.bodyText1,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Icon(
                                                                                                              Icons.circle_outlined,
                                                                                                              color: Theme.of(context).dividerColor,
                                                                                                            ),
                                                                                                            Icon(
                                                                                                              Icons.circle_outlined,
                                                                                                              color: Theme.of(context).dividerColor,
                                                                                                            ),
                                                                                                            Icon(
                                                                                                              Icons.circle_outlined,
                                                                                                              color: Theme.of(context).dividerColor,
                                                                                                            ),
                                                                                                            Icon(
                                                                                                              Icons.circle_outlined,
                                                                                                              color: Theme.of(context).dividerColor,
                                                                                                            ),
                                                                                                            Icon(
                                                                                                              Icons.circle_outlined,
                                                                                                              color: Theme.of(context).dividerColor,
                                                                                                            ),
                                                                                                            Icon(
                                                                                                              Icons.circle,
                                                                                                              color: Theme.of(context).hintColor,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              child: Text(
                                                                                                'Next',
                                                                                                style: Theme.of(context).textTheme.bodyText1,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.circle_outlined,
                                                                                            color: Theme.of(context).dividerColor,
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.circle_outlined,
                                                                                            color: Theme.of(context).dividerColor,
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.circle_outlined,
                                                                                            color: Theme.of(context).dividerColor,
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.circle_outlined,
                                                                                            color: Theme.of(context).dividerColor,
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.circle,
                                                                                            color: Theme.of(context).hintColor,
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.circle_outlined,
                                                                                            color: Theme.of(context).dividerColor,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              'Next',
                                                                              style: Theme.of(
                                                                                      context)
                                                                                  .textTheme
                                                                                  .bodyText1,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                          color: Theme.of(
                                                                                  context)
                                                                              .dividerColor,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                          color: Theme.of(
                                                                                  context)
                                                                              .dividerColor,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                          color: Theme.of(
                                                                                  context)
                                                                              .dividerColor,
                                                                        ),
                                                                        Icon(
                                                                          Icons.circle,
                                                                          color: Theme.of(
                                                                                  context)
                                                                              .hintColor,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                          color: Theme.of(
                                                                                  context)
                                                                              .dividerColor,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                          color: Theme.of(
                                                                                  context)
                                                                              .dividerColor,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                            'Next',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.circle_outlined,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                                      Icon(Icons.circle_outlined,
                                                          color: Theme.of(context)
                                                              .dividerColor),
                                                      Icon(Icons.circle,
                                                          color: Theme.of(context)
                                                              .hintColor),
                                                      Icon(
                                                        Icons.circle_outlined,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                                      Icon(
                                                        Icons.circle_outlined,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                                      Icon(
                                                        Icons.circle_outlined,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Next',
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Next',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              color: Theme.of(context).hintColor,
            ),
            Icon(
              Icons.circle_outlined,
              color: Theme.of(context).dividerColor,
            ),
            Icon(
              Icons.circle_outlined,
              color: Theme.of(context).dividerColor,
            ),
            Icon(
              Icons.circle_outlined,
              color: Theme.of(context).dividerColor,
            ),
            Icon(
              Icons.circle_outlined,
              color: Theme.of(context).dividerColor,
            ),
            Icon(
              Icons.circle_outlined,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      ],
    );
  }
}
