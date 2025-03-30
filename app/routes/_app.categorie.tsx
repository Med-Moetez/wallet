import { IconPlus } from "@tabler/icons-react";
import { motion } from "framer-motion"; // Animation library
import { useState } from "react";
import { gql, useMutation, useQuery } from "urql";
// Subscription to listen for categories (we'll keep it but not rely on it)
const CATEGORY_SUBSCRIPTION = gql`
  subscription CategorySubscription {
    categories {
      nodes {
        id
        name
      }
    }
  }
`;

// Mutation to add a category
const ADD_CATEGORY = gql`
  mutation ADD_CATEGORY($id: String!, $name: String!) {
    createCategory(input: { category: { id: $id, name: $name } }) {
      clientMutationId
    }
  }
`;

// Query to fetch categories
const GET_CATEGORIES = gql`
  query GET_CATEGORIES {
    categories {
      nodes {
        id
        name
      }
    }
  }
`;

const CategoriesPage = () => {
  const [categoryName, setCategoryName] = useState("");

  // Mutation hook to add a category
  const [, addCategory] = useMutation(ADD_CATEGORY);

  // Query hook to fetch categories
  const [{ data, error, fetching }, refetch] = useQuery({
    query: GET_CATEGORIES,
    requestPolicy: "network-only", // Always fetch fresh data
  });

  const handleAddCategory = async () => {
    if (categoryName.trim()) {
      const result = await addCategory({
        id: crypto.randomUUID(), // Generate unique ID
        name: categoryName,
      });

      console.log("Add Category Result:", result);

      // Check if category was added successfully
      if (result.data?.createCategory) {
        console.log("Category added successfully.");

        // Trigger refetch to update the list of categories
        refetch();

        // Clear input field after adding category
        setCategoryName("");
      } else {
        console.error("Failed to add category:", result.error?.message);
      }
    }
  };

  return (
    <div className="categories-page">
      <h1 className="mb-4 mt-10 text-xl font-semibold">Categories</h1>

      {/* Add Category Form */}
      <div className="mb-6 flex items-center space-x-4">
        <input
          type="text"
          placeholder="Category Name"
          value={categoryName}
          onChange={(e) => setCategoryName(e.target.value)}
          className="flex-1 rounded-lg border border-gray-300 p-3 shadow-sm focus:border-blue-500 focus:outline-none"
        />
        <button
          onClick={handleAddCategory}
          className="flex items-center rounded-lg bg-blue-600 px-4 py-3 text-white hover:bg-blue-700"
        >
          <IconPlus size={22} />
          <span className="ml-2">Add Category</span>
        </button>
      </div>

      {/* Loading or Error Message */}
      {fetching ? (
        <p>Loading categories...</p>
      ) : error ? (
        <p>Error: {error.message}</p>
      ) : (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-3">
          {data?.categories?.nodes?.map((category: any) => (
            <motion.div
              key={category.id}
              className="rounded-lg border border-gray-200 bg-white p-4 shadow hover:shadow-lg"
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.98 }}
            >
              <p className="text-lg font-semibold text-gray-800">
                {category.name}
              </p>
            </motion.div>
          ))}
        </div>
      )}
    </div>
  );
};

export default CategoriesPage;
