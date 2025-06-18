# 🌈 Lumea – AI-Powered Skin Tone Classifier & AR Makeup Try-On for iPad

**Lumea** is an iPad application that helps beauty enthusiasts find their ideal makeup shade using **machine learning** and **augmented reality**. With just one facial scan, users can receive personalized makeup recommendations and instantly try them on using AR — no more guesswork or trial-and-error.


---

## 🧩 Problem & Solution

### ❗ The Problem  
Beauty lovers often have a hard time selecting the perfect makeup shade.  
They may:

- Try products on their skin one-by-one  
- Ask for opinions from friends or family  
- Guess based on images or vague shade names  

These methods are usually **subjective**, **inconvenient**, and **inefficient**.

### 💡 The Solution – Lumea  
Lumea provides an **AI-powered, objective, and practical** approach. Simply:

1. Scan your face once using the iPad camera  
2. Let Lumea classify your skin tone using Core ML  
3. Instantly preview recommended shades via **AR Try-On**  
4. Email the result for future reference  

✨ Lumea simplifies your beauty journey with technology.

---

## 📌 Features

- 📸 One-scan skin tone detection with the iPad camera  
- 🤖 Core ML model trained with real image datasets  
- 🧴 Live AR Try-On to preview makeup shades on your face  
- 📧 Email feature to send shade suggestions and snapshots  
- 🎯 Skin tone classification via [SkinToneClassifier](https://github.com/ChenglongMa/SkinToneClassifier)  
- 💄 Designed specifically for iPad users and beauty fans

---

## 🧠 Machine Learning Workflow

### 1. **Dataset Collection**
We used a publicly available dataset:

> [Skin Tone Image Dataset – Hyper.AI](https://hyper.ai/en/datasets/21592)

It contains a diverse range of skin tones in varied lighting conditions.

### 2. **Labeling with SkinToneClassifier**
To automate data labeling into skin tone classes (Fair, Medium, Dark), we integrated:

> [SkinToneClassifier by Chenglong Ma](https://github.com/ChenglongMa/SkinToneClassifier)

This was used as a library to categorize the dataset efficiently.

### 3. **Training with CreateML**
We trained a custom image classification model using **CreateML**:

- Platform: macOS (CreateML app)  
- Input: Labeled skin tone dataset  
- Output: `.mlmodel` for direct integration in iOS  
- Classes: deep, tan, medium, light, and fair

---

## 🎨 AR Makeup Try-On

Lumea uses **ARKit** and **RealityKit** to enable live makeup try-on:

- Detects face in real-time  
- Applies suggested foundation shades to facial features  
- Users can swipe between shades to preview   

This helps users visualize how each product looks — without physically applying it.

---

## 📧 Email Reporting Feature

After analyzing skin tone and testing shades in AR, users can:

- Export results as a personalized report  
- Include recommended shades, accessories, hair, and shirt 
- Send directly to their email inbox

The email feature is powered by a lightweight backend using **Node.js**.

---

## 🛠️ Tech Stack

| Area             | Technology                            |
|------------------|----------------------------------------|
| Frontend         | SwiftUI + UIKit (iPad only)                    |
| AR Integration   | ARKit + RealityKit                     |
| ML Training      | CreateML (macOS)                       |
| Dataset          | Hyper.AI Skin Tone Dataset             |
| Labeling         | [SkinToneClassifier](https://github.com/ChenglongMa/SkinToneClassifier) |
| Model Runtime    | Core ML (.mlmodel)                     |
| Email Feature    | Swift + Node.js (API)                  |


