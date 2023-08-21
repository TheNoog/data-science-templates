#include <stdio.h>
#include <glpk.h>

int main(void) {
    // Create a GLPK problem object
    glp_prob *lp;
    lp = glp_create_prob();

    // Set the problem name
    glp_set_prob_name(lp, "Maximize_Profit");

    // Define the problem as a linear programming problem
    glp_set_obj_dir(lp, GLP_MAX);

    // Add rows (constraints)
    glp_add_rows(lp, 3);
    glp_set_row_name(lp, 1, "Resource_1");
    glp_set_row_bnds(lp, 1, GLP_UP, 0.0, 100.0);
    glp_set_row_name(lp, 2, "Resource_2");
    glp_set_row_bnds(lp, 2, GLP_UP, 0.0, 80.0);
    glp_set_row_name(lp, 3, "Product_A_Capacity");
    glp_set_row_bnds(lp, 3, GLP_UP, 0.0, 20.0);

    // Add columns (variables)
    glp_add_cols(lp, 2);
    glp_set_col_name(lp, 1, "Product_A");
    glp_set_col_bnds(lp, 1, GLP_LO, 0.0, 0.0);
    glp_set_col_kind(lp, 1, GLP_IV);
    glp_set_col_name(lp, 2, "Product_B");
    glp_set_col_bnds(lp, 2, GLP_LO, 0.0, 0.0);
    glp_set_col_kind(lp, 2, GLP_IV);

    // Set the objective coefficients
    glp_set_obj_coef(lp, 1, 10.0);
    glp_set_obj_coef(lp, 2, 15.0);

    // Add constraint coefficients
    // Resource constraints
    glp_set_mat_row(lp, 1, 2, (int[]){1, 2}, (double[]){2.0, 3.0});
    glp_set_mat_row(lp, 2, 2, (int[]){1, 2}, (double[]){4.0, 2.0});
    // Product A capacity
    glp_set_mat_row(lp, 3, 2, (int[]){1, 2}, (double[]){1.0, 0.0});

    // Solve the problem using the simplex method
    glp_simplex(lp, NULL);

    // Print the results
    printf("Product A units to produce: %.0f\n", glp_get_col_prim(lp, 1));
    printf("Product B units to produce: %.0f\n", glp_get_col_prim(lp, 2));
    printf("Total Profit: $%.2f\n", glp_get_obj_val(lp));

    // Clean up
    glp_delete_prob(lp);

    return 0;
}
