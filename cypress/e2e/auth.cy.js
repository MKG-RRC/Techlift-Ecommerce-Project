/// <reference types="cypress" />

const randomEmail = () => `test+${Date.now()}@example.com`;
const password = "Password123!";

describe("Authentication flows", () => {
  it("signs up successfully (happy path) and logs out", () => {
    const email = randomEmail();

    cy.visit("/users/sign_up");
    cy.get('input[name="user[email]"]').type(email);
    cy.get('input[name="user[password]"]').type(password);
    cy.get('input[name="user[password_confirmation]"]').type(password);
    cy.contains("button", "Sign Up").click();

    cy.url().should("match", /\/(products|)/);
    cy.contains(/(Welcome|signed up successfully)/i).should("exist");

    cy.contains("a", "Logout").click();
    cy.contains("a", "Log in").should("exist");
  });

  it("shows an error on invalid login (unhappy path)", () => {
    cy.visit("/users/sign_in");
    cy.get('input[name="user[email]"]').type("invalid@example.com");
    cy.get('input[name="user[password]"]').type("wrongpassword");
    cy.contains("button", "Log in").click();

    cy.contains(/Invalid Email or password/i).should("exist");
    cy.url().should("include", "/users/sign_in");
  });
});
