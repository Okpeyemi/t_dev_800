### **Phase 1: Understanding the Problem & Setting Up**
1. **Understand the Datasets (exploratory analysis)**  
   - Explore the datasets (structure, features, labels).  
   - Look for more elements to augment dataset
   - Translate images and filename to feature and target
   - Check for class balance (e.g., pneumonia vs. non-pneumonia).  

2. **Define Success Metrics**  
   - Choose key evaluation metrics: Accuracy, Precision, Recall, F1-Score, ROC-AUC.  
   - Justify why these metrics are appropriate for the problem.  

3. **Preprocess Data**  
   - Normalize, flatten and standardize pixel values if necessary.  

4. **Feature Engineering (Optional)**  
   - Apply **PCA** to reduce dimensionality and improve efficiency.  
   - Explore edge detection or other feature extraction methods.  

5. **Initial Data Visualization**  
   - Visualize sample images from each class.  
   - Check class distribution with histograms.  

---

### **Phase 2: Model Selection & Baseline**
6. **Implement a Simple Model First**  
   - Define a set of algorithms to test
   - Train and test on each model
   

7. **Train-Validation-Test Split**  
   - Implement **cross-validation** to ensure model robustness.  
   - Compare against a simple **train-test split** (as required in the project).  
   
8. **Choose the final model**
   - Compare results and choose 
---

### **Phase 4: Model Optimization & Fine-tuning**
9. **Hyperpa3ameter Tuning**  
   - Use **Grid Search** or **Random Search** to find optimal parameters.  
   - Test different architectures (deeper CNNs, ResNet, VGG, EfficientNet, etc.).  
   - Apply **Dropout, Batch Normalization, and Regularization** to prevent overfitting.  

10. **Compare Results Across Models**  
   - Use visualization (Confusion Matrices, ROC-AUC curves).  
   - Justify the best-performing model.  

---

### **Phase 5: Finalizing & Documentation**
11. **Save & Reuse the Best Model**  
    - Save model weights for future re-use (e.g., `model.save()` in TensorFlow).  
    - Validate that loading the saved model gives consistent results.  

12. **Expose model through an app**
    - Build API with Fastapi
    - Build frontend
    - Dockerize app

13. **Deliverables**  
    - **Technical Report** (Jupyter Notebook + HTML output with code, graphs, and conclusions).  
    - **Synthesis Document** (PDF with summarized results, figures, and key takeaways).  

14. **Bonus Features (Optional Enhancements)**  
    - Implement **Self-Organizing Maps** for visualization.  
    - Classify **No Pneumonia, Viral Pneumonia, Bacterial Pneumonia** as a multi-class problem.  
    - Experiment with **Neural Network Interpretability** (e.g., Grad-CAM for heatmaps).  

