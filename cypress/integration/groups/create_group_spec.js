/// <reference types="cypress" />

context('Group creation', () => {
  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsAdmin()
  })
  beforeEach(() => {
    const uuid = () => Cypress._.random(0, 1e6)

    Cypress.Cookies.preserveOnce('_decide_session')
    cy.fillGroupForm('Sample name ' + uuid())
  })

  it('create group', () => {
    cy.contains('Submit').click()

    cy.get('.alert.alert-info').should('contain', 'Group was successfully created.')
  })

  it('return an error when name is missing', () => {
    cy.get('#group_name').clear()
    cy.contains('Submit').click()

    cy.get('span').should('contain', 'can\'t be blank')
  })

  it('return an error when available votes is 0', () => {
    cy.get('#group_available_votes').clear().type('0')
    cy.contains('Submit').click()

    cy.get('span').should('contain', 'must be greater than or equal to 1')
  })
})
