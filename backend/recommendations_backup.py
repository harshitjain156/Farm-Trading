import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import sys
import json

# Read the data
products = pd.read_csv('output.csv', sep=',', encoding='latin-1',
                     usecols=['id','product_name', 'category', 'quantity', 'farmer_id'])

# Convert category to a string with space-separated values
products['category'] = products['category'].str.split('|')
products['category'] = products['category'].fillna("").astype('str')

# Define the TF-IDF vectorizer for category similarity
tf_category = TfidfVectorizer(analyzer='word', ngram_range=(1, 2), min_df=0, stop_words='english')
tfidf_matrix_category = tf_category.fit_transform(products['category'])

# Create a dictionary to map farmer_id to the corresponding category vector
farmer_category_dict = {}
for _, row in products.iterrows():
    farmer_id = row['farmer_id']
    if farmer_id not in farmer_category_dict:
        farmer_category_dict[farmer_id] = row['category']


# Function to compute the farmer similarity for a given product's category
def compute_farmer_similarity(product_category):
    tfidf_matrix_farmer = tf_category.transform([product_category])
    return cosine_similarity(tfidf_matrix_category, tfidf_matrix_farmer).flatten()


# Function to compute the category similarity between products
def compute_category_similarity():
    return cosine_similarity(tfidf_matrix_category, tfidf_matrix_category)


# Combine the similarity matrices (category and farmer) with weightage to prioritize farmer similarity
alpha = 0.7  # You can adjust this weightage as per your preference

cosine_sim_category = compute_category_similarity()
cosine_sim_combined = np.zeros(cosine_sim_category.shape)

for i in range(cosine_sim_category.shape[0]):
    product_category = products['category'][i]
    farmer_similarity = compute_farmer_similarity(product_category)
    cosine_sim_combined[i] = (alpha * cosine_sim_category[i]) + ((1 - alpha) * farmer_similarity)


# Function to get product recommendations based on category and farmer similarity
def product_recommendations(product_name):
    product_name_lower = product_name.lower()
    try:
        idx = products.index[products['product_name'].str.lower() == product_name_lower].tolist()[0]
    except IndexError:
        sys.stderr.write(f"Error: Product '{product_name}' not found in the data.\n")
        return []

    # Calculate the combined similarity score based on both product name and category
    sim_scores_name = list(enumerate(cosine_sim_combined[idx]))
    sim_scores_name = sorted(sim_scores_name, key=lambda x: x[1], reverse=True)
    sim_scores_name = sim_scores_name[1:21]

    product_category = products['category'][idx]
    farmer_similarity = compute_farmer_similarity(product_category)
    combined_similarity = (alpha * cosine_sim_category[idx]) + ((1 - alpha) * farmer_similarity)

    # Create a combined similarity score for each product based on both name and category
    combined_scores = [(i, alpha * sim + (1 - alpha) * farmer_similarity[i]) for i, sim in sim_scores_name]

    # Sort the combined scores and select the top 20 recommendations
    combined_scores = sorted(combined_scores, key=lambda x: x[1], reverse=True)
    combined_scores = combined_scores[1:21]

    # Extract the product IDs of the top recommendations
    recommended_ids = [products['id'][i] for i, _ in combined_scores]

    return recommended_ids


if __name__ == "__main__":
    product_name = sys.argv[1].strip().lower() if len(sys.argv) > 1 else 'Carrot'
    recommendations = product_recommendations(product_name)
    sys.stdout.write(json.dumps(recommendations))
