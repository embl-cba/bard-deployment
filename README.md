# BARD Desktop # 
BARD is a virtual desktop platform based on Kubernetes, developed for cloud-based bioimage analysis tasks. 
It was developed based on the open-source project [abcdesktop](https://abcdesktop.io). 
Everything in BARD, such as applications, system APIs etc are docker containers.

## Applications
All applications on BARD are standard containers with some BARD specifics, such as LABEL etc.
You can find all the application containers [here](https://github.com/embl-cba/bard-containers)

## Current Deployments ##
- EMBL internal BARD: https://bard.embl.de (used by EMBL staff for day-to-day image analysis)
- EMBL external BARD: https://bard-external.embl.de (used for external courses)
  
## Deploy your own BARD ##
1. [Install Kubernetes cluster](install-k8s.md) (optional if you already have a cluster)
2. [Deploy BARD](deploy-bard.md)

## Courses that used BARD as computing platform ##

|Course Name|No. of Participants  | Date|
|--|--|--|
|GloBIAS Training School, Kobe Japan| 52|25-29 Oct|
|EMBL Predoc Course||13-16 Oct 2025|
|EMBL Practical Adv. methods in Bioimage Analysis|26| Sept 2025|
|Lautenschlaeger Summer School|10|Septemper 2025|
|EMBL Internal course |13|25 September 2025|
|STRUCTURAL BIOLOGY 2.0 : integrating X-ray diffraction and modern computational tools”, Montevideo, Uruguay | 25 | 26-28 April 2025 |
|EMBL Advanced deep learning for image analysis   |  20 | Feb 17-24 2025|
|EMBO Practical Integrative structural biology: solving molecular puzzles   |  20 | Nov.17-24 2024|
|EMBL Pre-doc Course|14|Oct 21-25, 2024|
|EMBO Practical Current methods in cell biology|24|Sept. 2024|
|EMBO Advances in cryo-electron microscopy and 3D image processing|24|Aug. 2024|

  
# Contributing #
To contribute to the BARD, please open PR for any questions, bug fixes, feature requests etc.

# Citation #

Tischer, C., Hériché, J.-K., & Sun, Y. (2025). A Virtual Bioimage Analysis Research Desktop (BARD) for Deployment of Bioimage Tools on Kubernetes. Base4NFDI User Conference 2024 (UC4B2024), Berlin. Zenodo. https://doi.org/10.5281/zenodo.14643885






