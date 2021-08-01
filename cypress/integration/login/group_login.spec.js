context('Group login', () => {
  const groupName = 'Sample name ' + Cypress.uuid()

  before(() => {
    cy.loginAsAdmin()
    cy.createGroup(groupName)
  })

  beforeEach(() => {
    cy.clearCookies()
  })

  it('use valid auth code', () => {
    cy.loginAsGroup(groupName)
    cy.get('.navbar').should('contain', groupName)
  })

  it('use invalid auth code', () => {
    cy.loginWithCode('123456')
    cy.get('.alert.alert-danger').should('contain', 'Code is invalid or expired')
  })
})
