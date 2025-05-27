#!/bin/bash

output_file="audio_demo_blocks.html"
echo "" > "$output_file"

# 指定 demo 组顺序
groups=(
  "demo_audio_additional_16k"
  "demo_audio_additional_8k"
  "demo_from_songdes_16k"
  "demo_from_songdes_8k"
  "audiocaps_audioldm2"
  "musiccaps_qamdt"
  "librispeech_maskgct"
)

for group in "${groups[@]}"; do
  group_path="demos/$group"
  low_dir="$group_path/low"
  ours_dir="$group_path/ours"
  sr_dir="$group_path/audiosr"

  if [ -d "$low_dir" ] && [ -d "$ours_dir" ] && [ -d "$sr_dir" ]; then
    echo "<section class=\"section\">" >> "$output_file"
    echo "  <div class=\"container is-max-desktop\">" >> "$output_file"
    echo "    <h2 class=\"title is-3 has-text-centered\">Audio Demo: $group</h2>" >> "$output_file"
    echo "    <div class=\"columns is-multiline\">" >> "$output_file"

    for low_file in "$low_dir"/*.wav; do
      filename=$(basename "$low_file")
      base=${filename%%_8k.wav}
      base=${base%%.wav}

      ours_file=$(find "$ours_dir" -type f -name "*$base*.wav" | head -n 1)
      sr_file=$(find "$sr_dir" -type f -name "*$base*.wav" | head -n 1)

      if [ -f "$ours_file" ] && [ -f "$sr_file" ]; then
        echo "      <div class=\"column is-full\">" >> "$output_file"
        echo "        <p><b>Low</b></p>" >> "$output_file"
        echo "        <audio controls src=\"${low_file}\" style=\"width: 100%;\"></audio>" >> "$output_file"
        echo "        <p><b>Ours</b></p>" >> "$output_file"
        echo "        <audio controls src=\"${ours_file}\" style=\"width: 100%;\"></audio>" >> "$output_file"
        echo "        <p><b>AudioSR</b></p>" >> "$output_file"
        echo "        <audio controls src=\"${sr_file}\" style=\"width: 100%;\"></audio>" >> "$output_file"
        echo "      </div>" >> "$output_file"
      fi
    done

    echo "    </div>" >> "$output_file"
    echo "  </div>" >> "$output_file"
    echo "</section>" >> "$output_file"
  fi
done

echo "✅ HTML audio blocks written to $output_file"
