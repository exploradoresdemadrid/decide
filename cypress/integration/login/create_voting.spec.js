/// <reference types="cypress" />

context('Admin login', () => {
  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.login('admin@example.com', '12345678')
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
    cy.visit('http://localhost:3000/votings')
  })

  it('create simple voting', () => {
    cy.contains('Nueva votación').click()
    cy.contains('Title').click().type('Sample title')
    cy.contains('Description').click().type('Sample description')
    cy.contains('Enviar').click()
  })

  it('create secret voting', () => {
    cy.contains('Nueva votación').click()
    cy.contains('Title').click().type('Sample title')
    cy.contains('Description').click().type('Sample description')
    cy.contains('Secret').click()
    cy.contains('Enviar').click()
  })

  afterEach(() => {
    cy.get('.alert.alert-info').should('contain', 'Voting was successfully created.')
  })
})
