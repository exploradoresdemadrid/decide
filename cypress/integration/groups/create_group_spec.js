/// <reference types="cypress" />

context('Group creation', () => {
  let groupName

  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsAdmin()
  })
  beforeEach(() => {
    groupName = 'Sample group name 1'
    Cypress.Cookies.preserveOnce('_decide_session')
    cy.fillGroupForm(groupName)
  })

  it('create and delete group', () => {
    cy.percySnapshot();

    cy.contains('Submit').click()
    cy.get('.alert.alert-info').should('contain', 'Group was successfully created.')

    cy.get('#groups_index').contains('td', groupName).parent().contains('Destroy').click()
    cy.get('.alert.alert-info').should('contain', 'Group was successfully destroyed.')
  })

  it('return an error when name is missing', () => {
    cy.get('#group_name').clear()
    cy.contains('Submit').click()

    cy.get('span').should('contain', 'can\'t be blank')

    cy.percySnapshot();
  })
})
