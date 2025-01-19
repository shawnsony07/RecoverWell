
  # RecoverWell+

  RecoverWell+ is a comprehensive, technology-driven solution designed to support individuals undergoing addiction recovery. By integrating cutting-edge technologies like AI, wearable devices, and TinyML, the app delivers personalized recovery plans, real-time health tracking, and mental health support. The platform fosters a holistic approach to recovery by offering stress monitoring, virtual counseling, relapse prevention, and community engagement features.

  The app also includes tools for caregivers, enabling them to track progress, celebrate milestones, and access educational resources to better support their loved ones. Additionally, the RecoverWell+ Suite comprises complementary apps like FitWell for fitness tracking, CalmWell for mindfulness exercises, and ConnectWell for community-building, creating an ecosystem for long-term recovery success.

  With real-time alerts, AI-powered insights, and a robust network of community forums and events, RecoverWell+ addresses the core challenges of addiction recovery, empowering users and their families to achieve sustained progress and a healthier, more fulfilling life.


  ### List Models

  ollama list

  Returns list of local models.

  ### Create Model

  POST /api/create

  | Parameter | Type | Description |
  | :-------- | :------- | :------------------------- |
  | `name` | `string` | **Required**: Name for the model |
  | `path` | `string` | **Required**: Path to model file |
  | `modelfile` | `string` | **Optional**: Model configuration |

  ### Generate Response

  POST /api/generate

  | Parameter | Type | Description |
  | :-------- | :------- | :------------------------- |
  | `model` | `string` | **Required**: Name of the model to use |
  | `prompt` | `string` | **Required**: Input prompt for generation |
  | `stream` | `boolean` | **Optional**: Stream response tokens |
  | `options` | `object` | **Optional**: Generation parameters |

  ### Chat Completion

  POST /api/chat

  | Parameter | Type | Description |
  | :-------- | :------- | :------------------------- |
  | `model` | `string` | **Required**: Name of the model to use |
  | `messages` | `array` | **Required**: Array of message objects |
  | `stream` | `boolean` | **Optional**: Stream response tokens |
  | `options` | `object` | **Optional**: Generation parameters |

  ### Embeddings

  POST /api/embeddings

  | Parameter | Type | Description |
  | :-------- | :------- | :------------------------- |
  | `model` | `string` | **Required**: Name of the model to use |
  | `prompt` | `string` | **Required**: Text to generate embeddings for |
  | `options` | `object` | **Optional**: Generation parameters |

  ### Pull Model

  POST /api/pull

  | Parameter | Type | Description |
  | :-------- | :------- | :------------------------- |
  | `name` | `string` | **Required**: Name of model to download |
  | `insecure` | `boolean` | **Optional**: Skip TLS verification |

  ### Push Model 

  POST /api/push

  | Parameter | Type | Description |
  | :-------- | :------- | :------------------------- |
  | `name` | `string` | **Required**: Name of model to upload |
  | `insecure` | `boolean` | **Optional**: Skip TLS verification |

  ### Delete Model

  DELETE /api/delete

  | Parameter | Type | Description |
  | :-------- | :------- | :------------------------- |
  | `name` | `string` | **Required**: Name of model to delete |

  ## Run Ollama locally
  # Ollama

  Ollama allows you to run large language models locally on your machine. This guide will help you get started with pulling and running models using Ollama.

  ## Installation

  Before you begin, install Ollama for your operating system:

  - **macOS**: Download from [Ollama.ai](https://ollama.ai)
  - **Linux**: Run the following command:
    ```bash
    curl https://ollama.ai/install.sh | sh
    ```
  - **Windows**: Currently in beta, available through WSL2

  ## Pulling Models

  To download a model, use the `ollama pull` command followed by the model name:

  ```bash
  # Pull the Llama 2 model
  ollama pull llama2

  # Pull a specific model version
  ollama pull llama2:13b

  # Pull other popular models
  ollama pull mistral
  ollama pull codellama
  ollama pull llama2-uncensored
  ```

  Common available models include:
  - llama2 (default)
  - mistral
  - codellama
  - llama2-uncensored
  - neural-chat
  - vicuna
  - orca-mini

  ## Running Models

  ### Basic Usage

  Start a conversation with a model using:

  ```bash
  ollama run llama2
  ```

  This opens an interactive chat session where you can type messages and receive responses.

  ### Advanced Usage

  #### One-shot Responses

  Get a single response without entering interactive mode:

  ```bash
  ollama run llama2 "What is the capital of France?"
  ```

  #### Using with JSON Output

  Get structured JSON responses:

  ```bash
  ollama run llama2 --format json "List three fruits" 
  ```

  #### Model Parameters

  Customize model behavior with parameters:

  ```bash
  ollama run llama2 \
    --temperature 0.7 \
    --context-length 4096 \
    --top-p 0.9
  ```

  ### API Usage

  Ollama provides a REST API that runs on port 11434 by default. Example using curl:

  ```bash
  curl -X POST http://localhost:11434/api/generate -d '{
    "model": "llama2",
    "prompt": "Why is the sky blue?"
  }'
  ```

  ## Model Management

  List downloaded models:
  ```bash
  ollama list
  ```

  Remove a model:
  ```bash
  ollama rm llama2
  ```

  ## System Requirements

  - Minimum 8GB RAM (16GB+ recommended)
  - macOS 12+ / Linux / Windows with WSL2
  - x86_64 or ARM64 architecture

  ## Deployment

  To deploy this project run

  ```bash
    cd backend
    python server.py
  ```
  Once the server is running,
  Run the flutter project after entering the project folder.
  ```bash
    flutter run
  ```


  ## Run Locally

  Clone the project

  ```bash
    git clone https://github.com/shawnsony07/RecoverWell.git
  ```

  Go to the project directory

  ```bash
    cd chatapp
  ```

  Install dependencies

  ```bash
    pip install -r requirements.txt

  ```

  Start the server

  ```bash
    python server.py
  ```


  # Deploy on Android

  Android Installation Guide

  ## Install APK on Android

  ### Method 1: Direct Download
  1. Download the APK file from [Releases](https://github.com/yourusername/project/releases)
  2. On your Android device, open **Settings** → **Security**
  3. Enable **Unknown Sources** or **Install unknown apps**
  4. Navigate to the downloaded APK file using your file manager
  5. Tap the APK file and press **Install**

  ### Method 2: Using USB Cable
  1. Enable USB debugging on your Android device:
    - Go to **Settings** → **About phone**
    - Tap **Build number** 7 times to enable Developer options
    - Go back to **Settings** → **Developer options**
    - Enable **USB debugging**

  2. Connect your device to computer via USB cable

  3. Open terminal/command prompt and run:
  ```bash
  # Check if device is connected
  adb devices

  # Install APK
  adb install path/to/your-app.apk
  ```

  ### System Requirements
  - Android 6.0 (API level 23) or higher
  - At least 100MB free storage
  - Internet connection for model downloads

  ## Troubleshooting

  If you encounter installation issues:
  - Make sure you have sufficient storage space
  - Check if USB debugging is properly enabled
  - Ensure your device's screen is unlocked during installation
  - Try disconnecting and reconnecting USB cable
  ## Badges

  [![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
  [![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
  [![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)


  ## License

  [MIT](https://choosealicense.com/licenses/mit/)

