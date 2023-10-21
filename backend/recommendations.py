import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
import sys
import json

def load_data(file_path):
    # Load the CSV data into a DataFrame
    df = pd.read_csv(file_path)
    return df

def preprocess_data(df):
    # Combine relevant text fields into a single feature for content-based filtering
    #df['content'] = df['product_name'] + ' ' + df['category']
    df['content'] = df['product_name']

def get_recommendations(product_id, df):
    # Find the index of the input product_id
    product_index = df.index[df['id'] == product_id].tolist()[0]

    # Compute TF-IDF vectors for the 'content' feature
    tfidf_vectorizer = TfidfVectorizer()
    tfidf_matrix = tfidf_vectorizer.fit_transform(df['content'])

    # Calculate the cosine similarity between the input product and all other products
    cosine_similarities = linear_kernel(tfidf_matrix[product_index], tfidf_matrix)

    # Get the product indices sorted by similarity scores in descending order
    similar_indices = cosine_similarities[0].argsort()[::-1]

    # Filter out the unsimilar data and return recommended product IDs in a list
    recommended_products = [df['id'].iloc[i] for i in similar_indices if cosine_similarities[0][i] > 0]
    recommended_products = [item for item in recommended_products if item != product_id]
    return recommended_products

if __name__ == "__main__":
    # Replace 'output.csv' with the actual path to your CSV file
    data_file_path = 'output.csv'

    # Load the data
    data_df = load_data(data_file_path)

    # Preprocess the data
    preprocess_data(data_df)

    # Replace '6466c33d08bb89a9c55326da' with the ID of the product for which you want recommendations
#     input_product_id = '6466c33d08bb89a9c55326da'
    input_product_id = sys.argv[1].strip().lower() if len(sys.argv) > 1 else '6466c87c08bb89a9c55327ed'
#     recommendations = product_recommendations(product_name)
    # Get product recommendations
    recommendations = get_recommendations(input_product_id, data_df)
    sys.stdout.write(json.dumps(recommendations))