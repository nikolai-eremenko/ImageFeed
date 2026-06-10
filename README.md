# Image Feed
![iOS](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5-orange)
![UIKit](https://img.shields.io/badge/UIKit-Programmatic-black)

iOS application for browsing and interacting with images from the Unsplash platform.

This app demonstrates a complete UIKit-based application architecture with authentication, networking, image loading, and multi-screen navigation.

## Overview

Image Feed is a multi-screen iOS application that integrates with the Unsplash API and allows users to:

* Authenticate via OAuth 2.0
* Browse an infinite image feed
* View high-resolution images in fullscreen
* Like and save favorite images
* Access personal profile information

The project was implemented using **UIKit**, **MVC architecture**, and **programmatic UI layout**.

## Preview

<img src="https://github.com/user-attachments/assets/31a253d0-d597-448c-9d92-3a1b64bef474" width="280" />

## Features

### Authentication

* OAuth 2.0 authorization with Unsplash
* Secure access token flow
* Login state management

### Image Feed

* Infinite scrolling feed powered by Unsplash API
* Dynamic image loading
* Like / unlike images
* Loading indicators and error handling
* Placeholder support for failed image requests

### Fullscreen Image Viewer

* Fullscreen image presentation
* Zoom and pan gestures
* Share image via native iOS share sheet

### User Profile

* User profile information from Unsplash
* Avatar, username, and bio
* Logout flow with confirmation dialog
* Favorites collection support

## Tech Stack

* **Swift**
* **UIKit**
* **MVC**
* **Programmatic UI**
* **UITableView**
* **URLSession**
* **OAuth 2.0**
* **Unsplash API**

## Architecture

The application follows the **MVC (Model–View–Controller)** pattern and is organized into isolated feature modules:

* Authentication
* Image Feed
* Fullscreen Image Viewer
* Profile

The project focuses on building a maintainable UIKit application with screen-based navigation and API-driven content.

## What I Practiced in This Project

* Building a multi-screen UIKit application
* OAuth authentication flow
* Working with REST APIs
* Asynchronous networking
* State-driven UI updates
* Error handling and loading states
* Programmatic Auto Layout
* Table view performance and reusable cells
* Navigation architecture in UIKit

## Requirements

* iOS 13+
* Xcode 15+

## Getting Started

1. Clone the repository

```bash
git clone https://github.com/nikolai-eremenko/ImageFeed
```

2. Add your Unsplash API credentials

Create a configuration file and provide:

```swift
ACCESS_KEY
SECRET_KEY
REDIRECT_URI
ACCESS_SCOPE
BASE_URL
AUTH_URL
```

3. Run the project in Xcode

## About the Project

This repository represents one of my earlier UIKit projects and serves as a demonstration of foundational iOS engineering skills, including networking, OAuth authorization, screen composition, and API integration.
