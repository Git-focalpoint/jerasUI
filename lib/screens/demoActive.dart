/*
 * Copyright 2018, 2019, 2020, 2021 Dooboolab.
 *
 * This file is part of Flutter-Sound.
 *
 * Flutter-Sound is free software: you can redistribute it and/or modify
 * it under the terms of the Mozilla Public License version 2 (MPL2.0),
 * as published by the Mozilla organization.
 *
 * Flutter-Sound is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * MPL General Public License for more details.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */


import 'package:flutter_sound/flutter_sound.dart';

/// Factory used to track what codec is currently selected.
class ActiveCodec {
  static final ActiveCodec _self = ActiveCodec._internal();

  Codec? _codec = Codec.aacADTS;
  bool? _encoderSupported = false;
  bool _decoderSupported = false;

  ///
  FlutterSoundRecorder? recorderModule;

  /// Factory to access the active codec.
  factory ActiveCodec() {
    return _self;
  }
  ActiveCodec._internal();

  /// Set the active code for the the recording and player modules.
  void setCodec({required bool withUI, Codec? codec}) async {
    var player = FlutterSoundPlayer();
    if (withUI) {
      await player.openAudioSession(
          focus: AudioFocus.requestFocusAndDuckOthers, withUI: true);
      _encoderSupported = await recorderModule!.isEncoderSupported(codec!);
      _decoderSupported = await player.isDecoderSupported(codec);
    } else {
      await player.openAudioSession(
          focus: AudioFocus.requestFocusAndDuckOthers);
      _encoderSupported = await recorderModule!.isEncoderSupported(codec!);
      _decoderSupported = await player.isDecoderSupported(codec);
    }
    _codec = codec;
  }

  /// `true` if the active coded is supported by the recorder
  bool? get encoderSupported => _encoderSupported;

  /// `true` if the active coded is supported by the player
  bool get decoderSupported => _decoderSupported;

  /// returns the active codec.
  Codec? get codec => _codec;
}