import 'dart:async';

class Subscription<T> {
  final StreamController<T> _controller;

  final PubSub pubSub;

  final Iterable<String> subjects;

  bool _hasUnsubscribed = false;

  final Stream<T> stream;

  Subscription._(this.pubSub, this._controller, this.subjects)
      : stream = _controller.stream;

  void unsubscribe() => pubSub.unsubscribe(this);

  bool get hasUnsubscribed => _hasUnsubscribed;

  StreamSubscription<T> listen(void onData(T data),
      {Function onError, void onDone(), bool cancelOnError}) {
    return stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class PubSub<T> {
  final _subs = Map<String, Map<Subscription, StreamController<T>>>();

  void publish(/* String | Iterable<String> */ tags, T data) {
    final tagSet = Set<String>();
    if (tags is String)
      tagSet.add(tags);
    else if (tags is Iterable<String>)
      tagSet.addAll(tags);
    else if (tags is Iterable)
      tagSet.addAll(tags.map((v) => v?.toString()));
    else if (tags != null) tagSet.add(tags.toString());

    for (String tag in tagSet) {
      final tagSubs = _subs[tag];
      if (tagSubs == null) continue;

      for (StreamController controller in tagSubs.values) controller.add(data);
    }
  }

  Subscription<T> subscribe(/* String | Iterable<String> */ tags) {
    final tagSet = Set<String>();
    if (tags is String)
      tagSet.add(tags);
    else if (tags is Iterable<String>)
      tagSet.addAll(tags);
    else if (tags is Iterable)
      tagSet.addAll(tags.map((v) => v?.toString()));
    else if (tags != null) tagSet.add(tags.toString());

    final controller = StreamController<T>();
    Subscription<T> sub = Subscription<T>._(this, controller, tagSet);
    for (String tag in tagSet) {
      Map<Subscription, StreamController<T>> tagSubs = _subs[tag];
      if (tagSubs == null) _subs[tag] = tagSubs = {};
      tagSubs[sub] = controller;
    }

    return sub;
  }

  Future<void> unsubscribe(Subscription subscription) async {
    if (subscription.pubSub != this)
      throw Exception("Subscription does not belong to this pubsub.");
    if (subscription.hasUnsubscribed) return;

    for (String tag in subscription.subjects) {
      final tagSubs = _subs[tag];
      if (tagSubs == null) continue;
      tagSubs.remove(subscription);
    }
    await subscription._controller.close();
    subscription._hasUnsubscribed = true;
  }
}
