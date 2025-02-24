# BARD Desktop # 
BARD is a virtual desktop platform based on Kubernetes, developed for cloud-based bioimage analysis tasks. 
It was developed based on the open-source project [abcdesktop](https://abcdesktop.io)
Everything in BARD, such as applications, system APIs etc are docker containers.

## Current Deployment ##
- EMBL internal BARD: https://bard.embl.de (used by EMBL staff for day-to-day image analysis)
- EMBL external BARD: https://bard-external.embl.de (used for external courses)

## Applications
All applications on BARD are standard containers with some BARD specifics, such as LABEL etc.
You can find all the application containers [here](https://github.com/embl-cba/bard-containers)

## Courses that used BARD as computing platform ##
- EMBL Course, Advanced deep learning for image analysis 
- EMBO Practical, Integrative structural biology: solving molecular puzzles
- EMBL Pre-doc course
- EMBO Practical, Current methods in cell biology
- EMBO Advances in cryo-electron microscopy and 3D image processing

## Installation ##
1. [Install Kubernetes cluster](install-k8s.md) (optional if you already have a cluster)
2. [Deploy BARD](deploy-bard.md)

# Contributing #
To contribute to the BARD, please open PR for any questions, bug fixes, feature requests etc.

# Citation #

Tischer, C., Hériché, J.-K., & Sun, Y. (2025). A Virtual Bioimage Analysis Research Desktop (BARD) for Deployment of Bioimage Tools on Kubernetes. Base4NFDI User Conference 2024 (UC4B2024), Berlin. Zenodo. https://doi.org/10.5281/zenodo.14643885





