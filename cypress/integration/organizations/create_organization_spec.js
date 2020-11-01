/// <reference types="cypress" />

context('Organization creation', () => {
  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsSuperadmin()
  })
  beforeEach(() => {
    const uuid = () => Cypress._.random(0, 1e6)

    Cypress.Cookies.preserveOnce('_decide_session')
    cy.fillOrganizationForm('Sample name ' + uuid())
  })

  it('create organization', () => {
    cy.contains('Submit').click()

    cy.get('.alert.alert-info').should('contain', 'Organization was successfully created.')
    cy.percySnapshot();
  })

  it('return an error when name is missing', () => {
    cy.get('#organization_name').clear()
    cy.contains('Submit').click()

    cy.get('span').should('contain', 'can\'t be blank')
    cy.percySnapshot();
  })
})
