/// <reference types="cypress" />

context('Voting creation', () => {
  before(() => {
    cy.clearCookies()
    cy.loginAsAdmin()
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
    cy.visit('http://localhost:3000/')
  })

  it('create simple voting', () => {
    cy.createVoting('Sample title', {})
  })

  it('create secret voting', () => {
    cy.contains('New voting').click()
    cy.get('#new_voting').contains('Title').click().type('Sample title')
    cy.contains('Description').click().type('Sample description')
    cy.contains('Secret').click()

    cy.percySnapshot();

    cy.contains('Submit').click()

    cy.get('.alert.alert-info').should('contain', 'Voting was successfully created.')
  })
})
