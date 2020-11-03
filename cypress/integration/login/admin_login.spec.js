/// <reference types="cypress" />

context('Admin login', () => {
  before(() => {
    cy.clearCookies()
  })
  beforeEach(() => {
    cy.visit('http://localhost:3000/users/sign_in')
  })

  it('use valid admin password', () => {
    cy.loginAsAdmin()
    cy.get('.alert.alert-info').should('contain', 'Signed in successfully.')
    cy.get('.navbar-header').should('not.contain', 'organizations')
    cy.get('.navbar-header').should('contain', 'votings')
    cy.get('.navbar-header').should('contain', 'groups')
    cy.get('.navbar-header').should('contain', 'Sign out')
    cy.percySnapshot();
  })

  it('use valid superadmin password', () => {
    cy.loginAsSuperadmin()
    cy.get('.alert.alert-info').should('contain', 'Signed in successfully.')
    cy.get('.navbar-header').should('contain', 'organizations')
    cy.get('.navbar-header').should('contain', 'votings')
    cy.get('.navbar-header').should('contain', 'groups')
    cy.get('.navbar-header').should('contain', 'Sign out')
  })

  it('use invalid password', () => {
    cy.login('admin@example.com', 'invalidpass')
    cy.get('.alert.alert-danger').should('contain', 'Invalid Email or password.')
    cy.percySnapshot();
  })

  it('logout', () => {
    cy.loginAsAdmin()
    cy.logout()
    cy.percySnapshot();
  })
})
