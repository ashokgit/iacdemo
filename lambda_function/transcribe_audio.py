import torch
import librosa
from transformers import Wav2Vec2ForCTC, Wav2Vec2Tokenizer

def transcribe_audio(audio_file_path):
    # Load the audio file as a waveform
    waveform, sample_rate = librosa.load(audio_file_path, sr=16000)

    # Load the Whisper model and tokenizer
    model = Wav2Vec2ForCTC.from_pretrained("EleutherAI/gpt3-whisper")
    tokenizer = Wav2Vec2Tokenizer.from_pretrained("EleutherAI/gpt3-whisper")

    # Preprocess the audio waveform
    inputs = tokenizer(waveform, return_tensors="pt", padding=True)

    # Pass the preprocessed audio waveform through the Whisper model
    with torch.no_grad():
        logits = model(inputs.input_values, attention_mask=inputs.attention_mask).logits

    # Decode the predicted transcription from the logits
    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = tokenizer.batch_decode(predicted_ids)[0]

    return transcription