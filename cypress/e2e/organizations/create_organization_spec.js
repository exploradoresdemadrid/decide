/// <reference types="cypress" />

context('Organization creation', () => {
  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsSuperadmin()
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
    cy.fillOrganizationForm('Sample organization name 1')
  })

  it('create organization', () => {
    cy.percySnapshot();
    
    cy.contains('Submit').click()

    cy.get('.alert.alert-info').should('contain', 'Organization was successfully created.')
  })

  it('return an error when name is missing', () => {
    cy.get('#organization_name').clear()
    cy.contains('Submit').click()

    cy.get('span').should('contain', 'can\'t be blank')
  })
})
