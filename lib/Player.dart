// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.setAsset('/img/audio.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(
              child: Slider(
            min: 0,
            //max: player.duration!.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {},
          )),
          Row(
            children: [
              Text(position.toString()),
              Text(duration.toString()),
            ],
          ),
          SizedBox(child: ControlButtons(player)),
        ],
      ),
    ));
  }
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //PROBLEMA AQUI
    player.load;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 30.0,
                height: 30.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return FloatingActionButton(
                mini: true,
                onPressed: player.play,
                child: const Icon(Icons.play_arrow),
              );
            } else if (processingState != ProcessingState.completed ||
                player.duration == Duration.zero) {
              return FloatingActionButton(
                mini: true,
                onPressed: player.pause,
                child: const Icon(Icons.pause),
              );
            } else {
              return FloatingActionButton(
                mini: true,
                onPressed: () => player.seek(Duration.zero),
                child: const Icon(Icons.replay),
              );
            }
          },
        ),
      ],
    );
  }
}
