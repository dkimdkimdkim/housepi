BPM = 128
SPB = 60 * 1.0 / BPM
_1_16 = 0.25 * SPB
_1_8 = 0.5 * SPB
_1_4 = 1 * SPB
_1_2 = 2 * SPB
_1_1 = 4 * SPB

def dot(time)
  1.5 * time
end

define :_snap do
  sleep _1_8
  sample :perc_snap
  sleep _1_4
  sample :perc_snap
  sleep _1_8
end

define :_snare do
  sleep _1_4
  sample :sn_dolf
  sleep _1_4
end

define :_kick do
  sample :drum_heavy_kick
  sleep _1_4
end

define :_drum_standard do
  in_thread { _kick }
  in_thread { _snap }
  _snare
end

define :_triangles do |drop_last_note|
  7.times do
    sample :elec_triangle
    sleep _1_16
  end

  rate = drop_last_note ? 0.5 : 1
  sample :elec_triangle, rate: rate
  sleep _1_16
end

define :_drum_flourish do |drop_last_note|
  in_thread { _kick }
  _triangles drop_last_note
end

define :_drum_pattern do
  7.times do
    _drum_standard
  end
  _drum_flourish false

  7.times do
    _drum_standard
  end
  _drum_flourish true
end

define :_synth_line_a do
  use_synth :dsaw
  play_pattern_timed chord(:A4, :minor), _1_16
  play_pattern_timed chord(:A5, :minor), _1_16
  play_pattern_timed chord(:C4), _1_16
  play_pattern_timed chord(:C5), _1_16
  play_pattern_timed chord(:E4, :minor), _1_16
  play_pattern_timed chord(:E5, :minor), _1_16
  play_pattern_timed chord(:G4), _1_16
  play_pattern_timed chord(:G5), _1_16
  sleep _1_2
end

define :_synth_line_b do
  use_synth :dsaw
  play_pattern_timed chord(:A4, :minor), _1_16
  play_pattern_timed chord(:A5, :minor), _1_16
  play_pattern_timed chord(:C4), _1_16
  play_pattern_timed chord(:C5), _1_16
  play_pattern_timed chord(:E4, :minor), _1_16
  play_pattern_timed chord(:E5, :minor), _1_16
  play_pattern_timed chord(:Fs3), _1_16
  play_pattern_timed chord(:Fs4), _1_16
  sleep _1_2
end

define :synth_line do
  _synth_line_a
  _synth_line_b
end

define :_bass_line do
  play :A1, sustain: 3 * _1_8 - _1_16
  sleep 3 * _1_8
  play :C2, sustain: 3 * _1_8 - _1_16
  sleep 3 * _1_8
  play :E2, sustain: 3 * _1_8 - _1_16
  sleep 2 * 3 * _1_8 + _1_2

  play :A1, sustain: 3 * _1_8 - _1_16
  sleep 3 * _1_8
  play :C2, sustain: 3 * _1_8 - _1_16
  sleep 3 * _1_8
  play :E2, sustain: 3 * _1_8 - _1_16
  sleep 3 * _1_8
  play :Fs1, sustain: 3 * _1_8 - _1_16
  sleep 3 * _1_8 + _1_2
end

define :_intro do
  # just drums
  _drum_pattern

  # drums and bass line
  in_thread { _drum_pattern }
  2.times { _bass_line }

  # just synth
  synth_line

  # synth and bass
  in_thread { _bass_line }
  synth_line

  # everything
  in_thread { _drum_pattern }
  in_thread { 2.times { _bass_line } }
  2.times { synth_line }
end

define :_song do
  _intro
end

_song
